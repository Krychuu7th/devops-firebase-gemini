data "google_project" "current" {
  project_id = var.project_id
}

resource "google_project_service" "apikeys_api" { # Wymagane jest włączenie usługi API Keys API
  project = var.project_id
  service = "apikeys.googleapis.com"

  disable_on_destroy = false   # Usługa nie zostanie wyłączona np. podczas terraform destroy
}


resource "google_apikeys_key" "web_app_api_key" {
  name         = "firebase-web-app-key"
  display_name = "Firebase Web App API Key"
  project      = var.project_id

  restrictions {
    browser_key_restrictions {
      allowed_referrers = ["*"]
    }

    api_targets {
      service = "identitytoolkit.googleapis.com"
    }
  }

  depends_on = [
    google_project_service.apikeys_api,
    google_project_service.identitytoolkit
  ]   # Zasób zostanie utworzony dopiero gdy usługi zostaną włączone
}

data "google_firebase_web_app_config" "webapp_config" {
  web_app_id = google_firebase_web_app.default.app_id
  project    = var.project_id
  provider = google-beta
}
