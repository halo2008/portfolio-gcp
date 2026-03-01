# --- Infrastructure ---
resource "google_artifact_registry_repository" "repo" {
  depends_on    = [google_project_service.services]
  location      = var.region
  repository_id = "${var.app_name}-repo"
  format        = "DOCKER"
}
