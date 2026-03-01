resource "google_artifact_registry_repository_iam_member" "github_writer" {
  project    = var.project_id
  location   = var.region
  repository = google_artifact_registry_repository.repo.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_cloud_run_v2_service_iam_member" "github_run_admin" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.portfolio_app.name
  role     = "roles/run.admin"
  member   = "serviceAccount:${google_service_account.github_actions.email}"
}

locals {
  app_secret_ids = {
    "gemini"        = google_secret_manager_secret.gemini_key.id
    "qdrant"        = google_secret_manager_secret.qdrant_key.id
    "admin"         = google_secret_manager_secret.admin_secret.id
    "slack_token"   = google_secret_manager_secret.slack_token.id
    "slack_signing" = google_secret_manager_secret.slack_signing_secret.id
    "slack_channel" = google_secret_manager_secret.slack_channel_id.id
    "loki_host"     = google_secret_manager_secret.loki_host.id
    "loki_user"     = google_secret_manager_secret.loki_username.id
    "loki_pass"     = google_secret_manager_secret.loki_password.id
    "recaptcha"     = google_secret_manager_secret.recaptcha_secret_key.id
  }
}

resource "google_secret_manager_secret_iam_member" "app_sa_secret_access" {
  for_each  = local.app_secret_ids
  secret_id = each.value
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.app_sa.email}"
}
