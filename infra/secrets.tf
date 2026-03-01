# --- Secrets ---
resource "google_secret_manager_secret" "gemini_key" {
  depends_on = [google_project_service.services]
  secret_id  = "GEMINI_API_KEY"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "qdrant_key" {
  depends_on = [google_project_service.services]
  secret_id  = "QDRANT_API_KEY"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "admin_secret" {
  depends_on = [google_project_service.services]
  secret_id  = "ADMIN_SECRET"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "slack_token" {
  secret_id = "SLACK_BOT_TOKEN"
  replication {
    auto {}
  }
  depends_on = [google_project_service.services]
}

resource "google_secret_manager_secret" "slack_signing_secret" {
  secret_id = "SLACK_SIGNING_SECRET"
  replication {
    auto {}
  }
  depends_on = [google_project_service.services]
}

resource "google_secret_manager_secret" "slack_channel_id" {
  secret_id = "SLACK_CHANNEL_ID"
  replication {
    auto {}
  }
  depends_on = [google_project_service.services]
}

resource "google_secret_manager_secret" "loki_host" {
  secret_id = "LOKI_HOST"
  replication {
    auto {}
  }
  depends_on = [google_project_service.services]
}

resource "google_secret_manager_secret_version" "loki_host_initial" {
  secret      = google_secret_manager_secret.loki_host.id
  secret_data = "TO_BE_REPLACED"
  lifecycle {
    ignore_changes = [secret_data]
  }
}

resource "google_secret_manager_secret" "loki_username" {
  secret_id = "LOKI_USERNAME"
  replication {
    auto {}
  }
  depends_on = [google_project_service.services]
}

resource "google_secret_manager_secret_version" "loki_username_initial" {
  secret      = google_secret_manager_secret.loki_username.id
  secret_data = "TO_BE_REPLACED"
  lifecycle {
    ignore_changes = [secret_data]
  }
}

resource "google_secret_manager_secret" "loki_password" {
  secret_id = "LOKI_PASSWORD"
  replication {
    auto {}
  }
  depends_on = [google_project_service.services]
}

resource "google_secret_manager_secret_version" "loki_password_initial" {
  secret      = google_secret_manager_secret.loki_password.id
  secret_data = "TO_BE_REPLACED"
  lifecycle {
    ignore_changes = [secret_data]
  }
}

resource "google_secret_manager_secret" "recaptcha_secret_key" {
  secret_id = "RECAPTCHA_SECRET_KEY"
  replication {
    auto {}
  }
  depends_on = [google_project_service.services]
}
