resource "google_storage_bucket" "app_storage" {
  name     = var.project_id
  location = local.bucket_location
  storage_class = "REGIONAL"
  force_destroy = true # Pozwala usunąć bucket nawet jeśli zawiera pliki (default: false)
  uniform_bucket_level_access = true

  lifecycle_rule {
    condition {
      age = 7  # Warunek: plik jest starszy niż 7 dni
    }
    action {
      type = "Delete"  # Akcja: usuń plik
    }
  }
}

resource "google_project_service" "firebase_storage" { # Wymagane jest włączenie usługi Cloud Storage for Firebase API
  project = var.project_id
  service = "firebasestorage.googleapis.com"

  disable_on_destroy = false   # Usługa nie zostanie wyłączona np. podczas terraform destroy
}

resource "google_firebase_storage_bucket" "app_storage" {
  provider = google-beta  # Wymagany, ponieważ zasoby firebase są w dostępne jedynie w wersji beta,
                          # terraform domyślnie użyłby providera "google" co nie jest zalecane
                          # (https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/firebase_storage_bucket)
  project   = var.project_id
  bucket_id = google_storage_bucket.app_storage.id

  depends_on = [google_project_service.firebase_storage]   # Zasób zostanie utworzony dopiero gdy usługa Cloud Storage for Firebase API zostanie włączona
}

resource "null_resource" "storage_cors" { # Wykorzystanie null_resource do ustawienia reguł CORS dla bucketu Firebase Storage
  triggers = {
    bucket_id = google_storage_bucket.app_storage.id # Trigger powodujący ponowne wykonanie zasobu przy zmianie bucket_id
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo '[{"origin": ["*"],"method": ["GET","POST","PUT","DELETE","OPTIONS"],"responseHeader": ["Content-Type"],"maxAgeSeconds": 3600}]' > cors.json
      gcloud storage buckets update gs://${google_storage_bucket.app_storage.name} --cors-file=cors.json
      rm cors.json
    EOT
  }

  depends_on = [google_firebase_storage_bucket.app_storage]
}

# terraform import google_storage_bucket.app_storage devops-firebase-gemini.firebasestorage.app
