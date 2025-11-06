variable "project_id" {
  type        = string
  default     = "devops-firebase-gemini-tf"
  description = "GCP project identifier"
}

variable "provider_region" {
  type        = string
  default     = "europe-west1"
  description = "Region of infrastructure provider"
}

variable "database_region" {
  type        = string
  default     = "europe-west1"
  description = "Region of firebase database"
}

locals {
  site_id = var.project_id
  bucket_location = var.provider_region
  database_id = var.project_id
}
