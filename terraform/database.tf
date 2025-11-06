resource "google_project_service" "firebase_database" {
  provider = google-beta
  project  = var.project_id
  service  = "firebasedatabase.googleapis.com"

  disable_on_destroy = false   # Usługa nie zostanie wyłączona np. podczas terraform destroy
}

resource "time_sleep" "wait_2_minutes" { # Po uruchomieniu usługi Firebase Realtime Database Management API potrzeba chwili zanim będzie można utworzyć instancję bazy danych
  create_duration = "2m"
  depends_on = [google_project_service.firebase_database] # Zasób zostanie utworzony dopiero gdy usługa Firebase Realtime Database Management AP zostanie włączona
}

resource "google_firebase_database_instance" "default" {
  provider     = google-beta
  project      = var.project_id
  region       = var.database_region
  instance_id  = local.database_id

  depends_on = [time_sleep.wait_2_minutes]
  # Zasób zostanie utworzony dopiero gdy usługa Firebase Realtime Database Management AP zostanie włączona oraz
  # upłyną dodatkowe 2 minuty, tak by akcja mogła zostać rozpropagowana w infrastrukturze Google Cloud
}


# Należy zrobić research, w jaki sposób za pomocą terraform ustawić odpowiednie reguły bezpieczeństwa bazy danych dla Firebase Realtime Database
# Można spróbować użyć do tego null_resource
# Aktualne reguły:
# {
#   "rules": {
#     "users": {
#       "$uid": {
#         ".read": "$uid === auth.uid",
#         ".write": "$uid === auth.uid"
#       }
#     }
#   }
# }
