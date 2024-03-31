terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 6.21, < 7"
    }

    google = {
      source  = "hashicorp/google"
    }
  }
}
