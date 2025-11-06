resource "google_project_service" "identitytoolkit" { # Wymagane jest włączenie usługi Identity Toolkit API
  project = var.project_id
  service = "identitytoolkit.googleapis.com"

  disable_on_destroy = false   # Usługa nie zostanie wyłączona np. podczas terraform destroy
}

resource "google_identity_platform_config" "default" {
  project = var.project_id

  multi_tenant {
    allow_tenants = false
  }

  sign_in {
    email {
      enabled = true
    }
    phone_number {
      enabled = false
    }
  }

  depends_on = [google_project_service.identitytoolkit]   # Zasób zostanie utworzony dopiero gdy usługa Identity Toolkit API zostanie włączona
}

# terraform import google_identity_platform_config.default devops-firebase-gemini
