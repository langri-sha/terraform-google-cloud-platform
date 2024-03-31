terraform {
  required_version = ">= 1.3.6"

  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 6.21, < 7"
    }

    google = {
      source  = "hashicorp/google"
      version = ">= 5.22.0, < 6"
    }
  }
}
