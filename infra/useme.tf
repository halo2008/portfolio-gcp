# --- Cloud Scheduler for Useme polling ---
resource "google_cloud_scheduler_job" "useme_poll" {
  name        = "useme-poll"
  description = "Poll Useme offers via Gmail every 4 hours during business hours"
  schedule    = "0 8,12,16,20 * * *"
  time_zone   = "Europe/Warsaw"
  region      = var.region

  retry_config {
    retry_count = 2
  }

  http_target {
    http_method = "POST"
    uri         = "${google_cloud_run_v2_service.portfolio_app.uri}/api/useme/poll"

    headers = {
      "Content-Type" = "application/json"
    }

    # Poll token injected via OIDC (Cloud Scheduler -> Cloud Run auth)
    # Plus custom header for app-level auth
    oidc_token {
      service_account_email = google_service_account.app_sa.email
      audience              = google_cloud_run_v2_service.portfolio_app.uri
    }
  }

  depends_on = [
    google_project_service.services,
    google_cloud_run_v2_service.portfolio_app,
  ]
}
