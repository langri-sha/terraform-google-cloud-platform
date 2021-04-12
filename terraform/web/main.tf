terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "langri-sha"

    workspaces {
      name = "web"
    }
  }
}

locals {
  billing_account           = data.terraform_remote_state.org.outputs.billing_account
  org_domain                = data.terraform_remote_state.org.outputs.org_domain
  org_id                    = data.terraform_remote_state.org.outputs.org_id
  site_verifications        = data.terraform_remote_state.org.outputs.site_verifications
  web_folder                = data.terraform_remote_state.org.outputs.web_folder
  web_service_account_email = data.terraform_remote_state.org.outputs.web_service_account_email

  hosts = [
    "www",
    "production",
    "production-assets",
    "preview",
    "preview-assets",
  ]

  host_names = {
    "www"               = "www.${local.org_domain}",
    "production"        = local.org_domain,
    "production-assets" = "assets.${local.org_domain}",
    "preview"           = "preview.${local.org_domain}",
    "preview-assets"    = "assets.preview.${local.org_domain}",
  }

  host_redirects = {
    "www" = "production"
  }
}

provider "google" {
  alias = "access_token_resolver"
}

module "access_token_resolver" {
  source = "../modules/access-token-resolver"

  target_service_account = local.web_service_account_email

  providers = {
    google = google.access_token_resolver
  }
}

provider "google" {
  access_token = module.access_token_resolver.access_token
}

provider "google-beta" {
  access_token = module.access_token_resolver.access_token
}

data "terraform_remote_state" "org" {
  backend = "remote"

  config = {
    hostname     = "app.terraform.io"
    organization = "langri-sha"
    workspaces = {
      name = "org"
    }
  }
}

module "project_build" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.2.2"

  name = "build"

  auto_create_network     = false
  billing_account         = local.billing_account
  default_service_account = "deprivilege"
  folder_id               = local.web_folder
  org_id                  = local.org_id
  random_project_id       = "true"

  activate_apis = [
    "cloudbuild.googleapis.com",
    "compute.googleapis.com",
    "containerregistry.googleapis.com",
  ]
}

module "project_edge" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.2.2"

  name = "edge"

  billing_account         = local.billing_account
  default_service_account = "deprivilege"
  folder_id               = local.web_folder
  org_id                  = local.org_id
  random_project_id       = "true"

  activate_apis = [
    "compute.googleapis.com",
    "dns.googleapis.com",
  ]
}
