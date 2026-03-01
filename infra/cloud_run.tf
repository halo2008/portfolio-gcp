# --- Cloud Run Service ---
resource "google_cloud_run_v2_service" "portfolio_app" {
  name                = var.app_name
  location            = var.region
  ingress             = "INGRESS_TRAFFIC_ALL"
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
            secret  = google_secret_manager_secret.qdrant_key.secret_id
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
        name = "SLACK_CHANNEL_ID"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.slack_channel_id.secret_id
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
