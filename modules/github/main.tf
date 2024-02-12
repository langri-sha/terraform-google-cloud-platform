locals {
  id = "${replace(replace(data.github_repository.default, "_", "-"), "/", "-")}-gha"

  actions_variables = merge(var.actions_variables, {
    service_account            = google_service_account.github_actions.email
    workload_identity_provider = module.github_actions_workload_identity_federation.provider_name,
  })
}

data "github_repository" "default" {
  name      = var.name
  full_name = var.full_name
}

resource "github_actions_variable" "default" {
  for_each = local.actions_variables

  repository       = data.github_repository.default.name
  value            = each.value
  variable_name    = each.key
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
