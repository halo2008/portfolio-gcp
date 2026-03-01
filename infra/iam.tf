# --- IAM & Service Accounts ---
resource "google_service_account" "app_sa" {
  account_id   = "${var.app_name}-runner"
  display_name = "Cloud Run Runtime SA"
}

resource "google_service_account" "github_actions" {
  account_id   = "github-deployer"
  display_name = "GitHub Actions CI/CD SA"
}

resource "google_project_iam_member" "vertex_ai_access" {
  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}

resource "google_service_account_iam_member" "github_act_as_app_sa" {
  service_account_id = google_service_account.app_sa.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "firestore_access" {
  project = var.project_id
  role    = "roles/datastore.user"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}

moved {
  from = google_secret_manager_secret_iam_member.app_sa_recaptcha_accessor
  to   = google_secret_manager_secret_iam_member.app_sa_secret_access["recaptcha"]
}
