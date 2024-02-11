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
