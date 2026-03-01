# main.tf

resource "google_project_service" "services" {
  for_each = toset([
    "run.googleapis.com",
    "artifactregistry.googleapis.com",
    "aiplatform.googleapis.com",
    "secretmanager.googleapis.com",
    "firestore.googleapis.com",
    "cloudbuild.googleapis.com",
    "identitytoolkit.googleapis.com"
  ])
  service            = each.value
  disable_on_destroy = false
}

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

# --- Infrastructure ---
resource "google_artifact_registry_repository" "repo" {
  depends_on    = [google_project_service.services]
  location      = var.region
  repository_id = "${var.app_name}-repo"
  format        = "DOCKER"
}

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

resource "google_project_iam_member" "secret_access" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
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

# --- Cloud Run Service ---
resource "google_cloud_run_v2_service" "portfolio_app" {
  name     = var.app_name
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"
  deletion_protection = false

  depends_on = [
    google_secret_manager_secret_version.loki_host_initial,
    google_secret_manager_secret_version.loki_username_initial,
    google_secret_manager_secret_version.loki_password_initial
  ]

  template {
    service_account = google_service_account.app_sa.email

    scaling {
      min_instance_count = 1
      max_instance_count = 3
    }
    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.repository_id}/portfolio-app:latest"


      startup_probe {
        http_get {
          path = "/api/health"
          port = 8080
        }
        initial_delay_seconds = 15
        period_seconds        = 5
        failure_threshold     = 3
      }

      # Core app configuration
      env {
        name = "QDRANT_URL"
        value_source {
          secret_key_ref {
            secret  = "QDRANT_URL"
            version = "latest"
          }
        }
      }
      env {
        name = "GEMINI_API_KEY"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.gemini_key.secret_id
            version = "latest"
          }
        }
      }
      env {
        name = "RECAPTCHA_SECRET_KEY"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.recaptcha_secret_key.secret_id
            version = "latest"
          }
        }
      }
      env {
        name = "ADMIN_SECRET"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.admin_secret.secret_id
            version = "latest"
          }
        }
      }
      env {
        name = "QDRANT_API_KEY"
        value_source {
          secret_key_ref {
            secret = google_secret_manager_secret.qdrant_key.secret_id
            version = "latest"
          }
        }
      }
      env {
        name = "SLACK_BOT_TOKEN"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.slack_token.secret_id
            version = "latest"
          }
        }
      }
      env {
        name  = "SLACK_CHANNEL_ID"
        value_source {
          secret_key_ref {
            secret = google_secret_manager_secret.slack_channel_id.secret_id
            version = "latest"
          }
        }
      }

      env {
        name = "SLACK_SIGNING_SECRET"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.slack_signing_secret.secret_id
            version = "latest"
          }
        }
      }

      env {
        name = "LOKI_HOST"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.loki_host.secret_id
            version = "latest"
          }
        }
      }

      env {
        name = "LOKI_USERNAME"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.loki_username.secret_id
            version = "latest"
          }
        }
      }

      env {
        name = "LOKI_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.loki_password.secret_id
            version = "latest"
          }
        }
      }

      resources {
        limits = {
          cpu    = "1000m"
          memory = "512Mi"
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      template[0].containers[0].image,
      client,
      client_version
    ]
  }
}

# --- Public Access ---
resource "google_cloud_run_service_iam_member" "public_access" {
  service  = google_cloud_run_v2_service.portfolio_app.name
  location = google_cloud_run_v2_service.portfolio_app.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# --- GitHub CI/CD Permissions ---
resource "google_project_iam_member" "github_ar_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_secret_manager_secret" "recaptcha_secret_key" {
  secret_id = "RECAPTCHA_SECRET_KEY"
  replication {
    auto {}
  }
  depends_on = [google_project_service.services]
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

resource "google_service_account_key" "github_actions_key" {
  service_account_id = google_service_account.github_actions.name
}

resource "google_firestore_database" "database" {
  project     = var.project_id
  name        = "(default)"
  location_id = var.region
  type        = "FIRESTORE_NATIVE"

  depends_on = [google_project_service.services]
}

resource "google_project_iam_member" "firestore_access" {
  project = var.project_id
  role    = "roles/datastore.user"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}

resource "google_cloud_run_domain_mapping" "default" {
  location = var.region
  name     = "ks-infra.dev" # Twoja domena

  metadata {
    namespace = var.project_id
  }

  spec {
    route_name = google_cloud_run_v2_service.portfolio_app.name
  }
}

resource "google_secret_manager_secret_iam_member" "app_sa_recaptcha_accessor" {
  secret_id = google_secret_manager_secret.recaptcha_secret_key.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.app_sa.email}"
}
