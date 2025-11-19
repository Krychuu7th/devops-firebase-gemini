resource "google_project_service" "firebase_vertex_ai" {
  project = var.project_id
  service = "firebasevertexai.googleapis.com"

  disable_on_destroy = false
}

resource "google_project_service" "vertex_ai" {
  project = var.project_id
  service = "aiplatform.googleapis.com"

  disable_on_destroy = false
}
