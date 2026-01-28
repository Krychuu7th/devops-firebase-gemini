resource "google_project_service" "api_keys" { # Wymagane jest włączenie usługi API Keys API
  project = var.project_id
  service = "apikeys.googleapis.com"

  disable_on_destroy = false   # Usługa nie zostanie wyłączona np. podczas terraform destroy
}

resource "google_project_service" "iam" { # Wymagane jest włączenie usługi IAM Api
  project = var.project_id
  service = "iam.googleapis.com"

  disable_on_destroy = false
}

resource "google_project_service" "cloud_build" { # Wymagane jest włączenie usługi Cloud Build API
  project = var.project_id
  service = "cloudbuild.googleapis.com"

  disable_on_destroy = false
}

resource "google_project_service" "eventarc" { # Wymagane jest włączenie usługi Eventarc API
  project = var.project_id
  service = "eventarc.googleapis.com"

  disable_on_destroy = false
}

resource "google_project_service" "cloud_run_admin" { # Wymagane jest włączenie usługi Cloud Run Admin API
  project = var.project_id
  service = "run.googleapis.com"

  disable_on_destroy = false
}

resource "time_sleep" "wait_1_minute" {
  create_duration = "1m"
  depends_on = [
    google_project_service.api_keys,
    google_project_service.iam,
    google_project_service.cloud_build,
    google_project_service.eventarc,
    google_project_service.cloud_run_admin
  ]
}

resource "google_storage_bucket" "functions" {
  name     = "${var.project_id}-functions"
  location = var.region
}

resource "google_storage_bucket_object" "function_zip" {
  name   = "dfg-send-error-report-${filemd5("../dfg-send-error-report/functions/index.js")}.zip" # hashowanie wymusza ponowny uploadu przy zmianie kodu funkcji
  bucket = google_storage_bucket.functions.name
  source = data.archive_file.function_source.output_path
}

data "archive_file" "function_source" {
  type        = "zip"
  source_dir  = "../dfg-send-error-report/functions"
  output_path = "/tmp/function-source.zip"
}

resource "google_cloudfunctions2_function" "send_error_report" {
  name     = "dfg-send-error-report"
  location = var.region

  build_config {
    runtime     = "nodejs20"
    entry_point = "sendErrorReport"
    source {
      storage_source {
        bucket = google_storage_bucket.functions.name
        object = google_storage_bucket_object.function_zip.name
      }
    }
  }

  service_config {
    available_memory   = "256Mi"
    timeout_seconds    = 60
    environment_variables = {
      SMTP_HOST   = var.smtp_host
      SMTP_PORT   = var.smtp_port
      SMTP_SENDER = var.smtp_sender
      RECIPIENTS  = var.recipients
      PROJECT_ID  = var.project_id
      LOCATION    = var.region
      MODEL       = var.model
      SMTP_USER   = var.smtp_user
      SMTP_PASS   = var.smtp_pass
    }
  }

  event_trigger {
    trigger_region        = var.region
    event_type            = "google.firebase.database.ref.v1.created"
    retry_policy          = "RETRY_POLICY_RETRY"
    service_account_email = "dfg-error-report-sa@devops-firebase-gemini-tf.iam.gserviceaccount.com"

    event_filters {
      attribute = "ref"
      value     = "/errorReports/{pushId}"
      operator  = "match-path-pattern"
    }

    event_filters {
      attribute = "instance"
      value     = "devops-firebase-gemini-tf-test"
    }
  }

  depends_on = [time_sleep.wait_1_minute]
}
