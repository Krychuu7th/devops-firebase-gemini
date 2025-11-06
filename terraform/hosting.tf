resource "google_firebase_web_app" "default" {
  provider = google-beta
  project  = var.project_id
  display_name = "Devops Firebase Gemini Terraform Web App"
}

resource "google_firebase_hosting_site" "site" {
  provider = google-beta
  project  = var.project_id
  site_id  = local.site_id
  app_id = google_firebase_web_app.default.app_id
}

# terraform import google_firebase_hosting_site.site projects/devops-firebase-gemini/sites/devops-firebase-gemini
