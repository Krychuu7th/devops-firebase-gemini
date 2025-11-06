terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 7.0"
    }
    time = {
      source = "hashicorp/time"
      version = "0.13.1"
    }
    null = {
      source = "hashicorp/null"
      version = "3.2.4"
    }
  }
}
