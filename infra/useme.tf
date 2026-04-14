resource "google_service_account" "scheduler_sa" {
  account_id   = "cloud-scheduler-invoker"
  display_name = "Cloud Scheduler Service Account"
}

resource "google_cloud_run_service_iam_member" "scheduler_invoker" {
  service  = google_cloud_run_v2_service.ks-portfolio.name
  location = google_cloud_run_v2_service.ks-portfolio.location
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.scheduler_sa.email}"
}

resource "google_cloud_scheduler_job" "lab_cleanup" {
  name             = "lab-cleanup"
  description      = "Trigger expired demo user cleanup every hour"
  schedule         = "0 * * * *"
  time_zone        = "UTC"
  attempt_deadline = "120s"

  http_target {
    http_method = "POST"
    uri         = "${google_cloud_run_v2_service.ks-portfolio.uri}/api/scheduler/cleanup"

    headers = {
      "x-cloud-scheduler-secret" = random_password.cloud_scheduler_secret.result
    }

    oidc_token {
      service_account_email = google_service_account.scheduler_sa.email
      audience              = google_cloud_run_v2_service.ks-portfolio.uri
    }
  }

  depends_on = [google_project_service.services]
}
