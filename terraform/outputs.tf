output "project_number" {
  value = data.google_project.current.number
}

output "project_billing_acc" {
  value = data.google_project.current.billing_account
}

output "hosting_site_id" {
  value = google_firebase_hosting_site.site.site_id
}

output "bucket_name" {
  value = google_storage_bucket.app_storage.name
}

output "firebase_config" { # Tworzy konfigurację Firebase, którą można wkleić do konfiguracji aplikacji (environment)
  value = <<-EOT
    firebase: {
      apiKey: "${data.google_firebase_web_app_config.webapp_config.api_key}",
      authDomain: "${data.google_firebase_web_app_config.webapp_config.auth_domain}",
      projectId: "${var.project_id}",
      databaseURL: "${google_firebase_database_instance.default.database_url}/",
      storageBucket: "${google_firebase_storage_bucket.app_storage.bucket_id}",
      appId: "${google_firebase_web_app.default.app_id}",
    },
  EOT
  sensitive = true
}
