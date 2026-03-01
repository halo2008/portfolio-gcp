# --- Identity Platform ---
resource "google_identity_platform_config" "default" {
  project = var.project_id

  sign_in {
    allow_duplicate_emails = false
    email {
      enabled           = true
      password_required = true
    }
  }

  depends_on = [google_project_service.services]
}
