# Service Accounts
resource "google_service_account" "app_sa" {
  account_id   = "${var.app_name}-runner"
  display_name = "Cloud Run Runtime Service Account"
}

resource "google_service_account" "github_actions" {
  account_id   = "github-deployer"
  display_name = "GitHub Actions CI/CD Service Account"
}

# Runtime Permissions (app_sa)
resource "google_project_iam_member" "app_vertex_ai" {
  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}

resource "google_project_iam_member" "app_firestore" {
  project = var.project_id
  role    = "roles/datastore.user"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}

resource "google_project_iam_member" "app_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}

# CI/CD Permissions (github_actions)
resource "google_project_iam_member" "github_registry_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "github_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_service_account_iam_member" "github_act_as_app_sa" {
  service_account_id = google_service_account.app_sa.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.github_actions.email}"
}

# State Migrations

# --- Migracja Kontenerów Sekretów ---
moved {
  from = google_secret_manager_secret.gemini_key
  to   = google_secret_manager_secret.secrets["GEMINI_API_KEY"]
}
moved {
  from = google_secret_manager_secret.qdrant_key
  to   = google_secret_manager_secret.secrets["QDRANT_API_KEY"]
}
moved {
  from = google_secret_manager_secret.admin_secret
  to   = google_secret_manager_secret.secrets["ADMIN_SECRET"]
}
moved {
  from = google_secret_manager_secret.recaptcha_secret_key
  to   = google_secret_manager_secret.secrets["RECAPTCHA_SECRET_KEY"]
}
moved {
  from = google_secret_manager_secret.loki_host
  to   = google_secret_manager_secret.secrets["LOKI_HOST"]
}
moved {
  from = google_secret_manager_secret.loki_username
  to   = google_secret_manager_secret.secrets["LOKI_USERNAME"]
}
moved {
  from = google_secret_manager_secret.loki_password
  to   = google_secret_manager_secret.secrets["LOKI_PASSWORD"]
}
moved {
  from = google_secret_manager_secret.slack_token
  to   = google_secret_manager_secret.secrets["SLACK_BOT_TOKEN"]
}
moved {
  from = google_secret_manager_secret.slack_signing_secret
  to   = google_secret_manager_secret.secrets["SLACK_SIGNING_SECRET"]
}
moved {
  from = google_secret_manager_secret.slack_channel_id
  to   = google_secret_manager_secret.secrets["SLACK_CHANNEL_ID"]
}

# --- Migracja Uprawnień IAM do Sekretów (Klucze: małe -> wielkie + zmiana nazwy zasobu) ---
moved {
  from = google_secret_manager_secret_iam_member.app_sa_secret_access["gemini"]
  to   = google_secret_manager_secret_iam_member.accessor["GEMINI_API_KEY"]
}
moved {
  from = google_secret_manager_secret_iam_member.app_sa_secret_access["qdrant"]
  to   = google_secret_manager_secret_iam_member.accessor["QDRANT_API_KEY"]
}
moved {
  from = google_secret_manager_secret_iam_member.app_sa_secret_access["qdrant_url"]
  to   = google_secret_manager_secret_iam_member.accessor["QDRANT_URL"]
}
moved {
  from = google_secret_manager_secret_iam_member.app_sa_secret_access["admin"]
  to   = google_secret_manager_secret_iam_member.accessor["ADMIN_SECRET"]
}
moved {
  from = google_secret_manager_secret_iam_member.app_sa_secret_access["recaptcha"]
  to   = google_secret_manager_secret_iam_member.accessor["RECAPTCHA_SECRET_KEY"]
}
moved {
  from = google_secret_manager_secret_iam_member.app_sa_secret_access["loki_host"]
  to   = google_secret_manager_secret_iam_member.accessor["LOKI_HOST"]
}
moved {
  from = google_secret_manager_secret_iam_member.app_sa_secret_access["loki_user"]
  to   = google_secret_manager_secret_iam_member.accessor["LOKI_USERNAME"]
}
moved {
  from = google_secret_manager_secret_iam_member.app_sa_secret_access["loki_pass"]
  to   = google_secret_manager_secret_iam_member.accessor["LOKI_PASSWORD"]
}
moved {
  from = google_secret_manager_secret_iam_member.app_sa_secret_access["slack_token"]
  to   = google_secret_manager_secret_iam_member.accessor["SLACK_BOT_TOKEN"]
}
moved {
  from = google_secret_manager_secret_iam_member.app_sa_secret_access["slack_signing"]
  to   = google_secret_manager_secret_iam_member.accessor["SLACK_SIGNING_SECRET"]
}
moved {
  from = google_secret_manager_secret_iam_member.app_sa_secret_access["slack_channel"]
  to   = google_secret_manager_secret_iam_member.accessor["SLACK_CHANNEL_ID"]
}

# --- Migracja Wersji (Zachowanie kluczy) ---
moved {
  from = google_secret_manager_secret_version.loki_host_initial
  to   = google_secret_manager_secret_version.secret_versions["LOKI_HOST"]
}
moved {
  from = google_secret_manager_secret_version.loki_username_initial
  to   = google_secret_manager_secret_version.secret_versions["LOKI_USERNAME"]
}
moved {
  from = google_secret_manager_secret_version.loki_password_initial
  to   = google_secret_manager_secret_version.secret_versions["LOKI_PASSWORD"]
}

# --- Migracja Rol Projektowych (Ujednolicenie nazw) ---
moved {
  from = google_project_iam_member.firestore_access
  to   = google_project_iam_member.app_firestore
}
moved {
  from = google_project_iam_member.vertex_ai_access
  to   = google_project_iam_member.app_vertex_ai
}

moved {
  from = google_secret_manager_secret.qdrant_url
  to   = google_secret_manager_secret.secrets["QDRANT_URL"]
}

moved {
  from = google_cloud_run_v2_service.portfolio_app
  to   = google_cloud_run_v2_service.ks-portfolio
}
