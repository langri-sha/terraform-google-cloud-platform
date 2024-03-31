terraform {
  required_version = ">= 1.3.6"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.22.0, < 6"
    }
  }
}
