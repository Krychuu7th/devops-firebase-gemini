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

variable "region" {
  type    = string
  default = "europe-west1"
}

variable "smtp_host" {
  type    = string
  default = "in-v3.mailjet.com"
}

variable "smtp_port" {
  type    = string
  default = "587"
}

variable "smtp_user" {
  type      = string
  sensitive = true
}

variable "smtp_pass" {
  type      = string
  sensitive = true
}

variable "smtp_sender" {
  type    = string
  default = "dfg-alert@tempmailto.org"
}

variable "recipients" {
  type = string
}

variable "model" {
  type    = string
  default = "gemini-2.0-flash-lite"
}
