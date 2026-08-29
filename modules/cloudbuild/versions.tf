terraform {
  required_version = ">= 1.3.6"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "< 9"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "< 9"
    }
  }
}
