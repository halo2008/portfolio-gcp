# --- Secret Manager Configuration ---

variable "secret_ids" {
  type    = list(string)
  default = [
    "GEMINI_API_KEY",
    "QDRANT_API_KEY",
    "QDRANT_URL", # Added for consistency with infrastructure requirements
    "ADMIN_SECRET",
    "SLACK_BOT_TOKEN",
    "SLACK_SIGNING_SECRET",
    "SLACK_CHANNEL_ID",
    "LOKI_HOST",
    "LOKI_USERNAME",
    "LOKI_PASSWORD",
    "RECAPTCHA_SECRET_KEY",
    "GRAFANA_METRICS_USER",
    "GRAFANA_METRICS_PASSWORD"
  ]
}

resource "google_secret_manager_secret" "secrets" {
  for_each  = toset(var.secret_ids)
  secret_id = each.key

  replication {
    auto {}
  }

  depends_on = [google_project_service.services]
}

resource "google_secret_manager_secret_version" "secret_versions" {
  for_each    = toset(var.secret_ids)
  secret      = google_secret_manager_secret.secrets[each.key].id
  secret_data = "PLACEHOLDER"

  lifecycle {
    ignore_changes = [secret_data]
  }
}

resource "google_secret_manager_secret_iam_member" "accessor" {
  for_each  = toset(var.secret_ids)
  secret_id = google_secret_manager_secret.secrets[each.key].id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.app_sa.email}"
}