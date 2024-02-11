locals {
  id = "${replace(replace(data.github_repository.default, "_", "-"), "/", "-")}-gha"
}


data "github_repository" "default" {
  name      = var.name
  full_name = var.full_name
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
