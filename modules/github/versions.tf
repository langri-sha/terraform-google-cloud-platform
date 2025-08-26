terraform {
  required_version = ">= 1.3.6"

  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 6.2.1, < 7"
    }

    google = {
      source  = "hashicorp/google"
      version = "< 8"
    }
  }
}
