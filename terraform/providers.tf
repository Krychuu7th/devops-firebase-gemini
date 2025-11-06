provider "google" {
  project               = var.project_id
  region                = var.provider_region
  user_project_override = true
  billing_project       = var.project_id
}

provider "google-beta" {
  project               = var.project_id
  region                = var.provider_region
  user_project_override = true
  billing_project       = var.project_id
}

# Providery hashicorp/time, hashicorp/null nie potrzebują konfiguracji
