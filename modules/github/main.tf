locals {
  id = "${replace(replace(replace(data.github_repository.default.full_name, ".", "-"), "_", "-"), "/", "--")}-gha"

  actions_variables = merge(var.actions_variables, {
    service_account            = google_service_account.github_actions.email
    workload_identity_provider = module.github_actions_workload_identity_federation.provider_name,
  })

  environments_variables = {
    for each in flatten([
      for environment, vars in local.environment_variables : [
        for variable_name, value in vars : {
          environment   = environment
          variable_name = variable_name
          value         = value
        }
      ]
    ]) : "${each.environment}_${each.variable_name}" => each
  }
}

data "github_repository" "default" {
  name      = var.name
  full_name = var.full_name
}

resource "github_repository_environment" "default" {
  for_each = var.actions_environments

  environment = each.key
  repository  = github_repository.default.name

  can_admins_bypass   = try(each.value.can_admins_bypass, null)
  prevent_self_review = try(each.value.prevent_self_review, null)
  wait_timer          = try(each.value.wait_timer, null)

  dynamic "deployment_branch_policy" {
    for_each = each.value.deployment_branch_policy != null ? [each.value.deployment_branch_policy] : []

    content {
      protected_branches     = deployment_branch_policy.value.protected_branches
      custom_branch_policies = deployment_branch_policy.value.custom_branch_policies
    }
  }

  reviewers {
    teams = try(each.value.reviewers.teams, null)
    users = try(each.value.reviewers.users, null)
  }
}

resource "github_actions_environment_variable" "default" {
  for_each = local.environments_variables

  environment   = each.value.environment
  value         = each.value.value
  variable_name = each.value.variable_name
}

resource "github_actions_variable" "default" {
  for_each = local.actions_variables

  repository    = data.github_repository.default.name
  value         = each.value
  variable_name = each.key
}

resource "github_actions_secret" "secret" {
  for_each = {
    for name, secret in try(nonsensitive(var.actions_secrets), {}) :
    name => sensitive(secret)
  }

  repository      = data.github_repository.default.name
  secret_name     = each.key
  plaintext_value = each.value
}

resource "google_service_account" "github_actions" {
  account_id   = local.id
  display_name = "GitHub Actions (${data.github_repository.default.full_name})"
  project      = var.project
}

resource "random_id" "pool_id" {
  byte_length = 8
}

module "github_actions_workload_identity_federation" {
  source  = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  version = ">= 3.1.0"

  project_id  = var.project
  pool_id     = "github-actions-${random_id.pool_id.hex}"
  provider_id = "github-provider-${random_id.pool_id.hex}"
  sa_mapping = {
    "github-actions" = {
      sa_name   = google_service_account.github_actions.id
      attribute = "attribute.repository/${data.github_repository.default.full_name}"
    }
  }
}

data "github_repository" "deploy_key" {
  for_each = var.deploy_key

  full_name = each.key
}

resource "tls_private_key" "deploy_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "github_repository_deploy_key" "deploy_key" {
  for_each = var.deploy_key

  repository = data.github_repository.deploy_key[each.key].name
  title      = "${data.github_repository.default.full_name} deploy key"
  key        = tls_private_key.deploy_key.public_key_openssh
  read_only  = each.value.read_only
}
