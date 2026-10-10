terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {}

provider "google" {
  alias = "billing"
}

module "workspace" {
  source = "../../modules/workspace"

  name                  = "example"
  admin_members         = ["group:admins@example.com"]
  billing_account       = "000000-000000-000000"
  org_id                = "000000000000"
  org_project_id        = "example"
  service_account_roles = ["roles/editor"]

  providers = {
    google         = google
    google.billing = google.billing
  }
}
