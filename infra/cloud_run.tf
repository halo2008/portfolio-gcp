# --- Cloud Run Service ---
resource "google_cloud_run_v2_service" "portfolio_app" {
  name                = var.app_name
  location            = var.region
  ingress             = "INGRESS_TRAFFIC_ALL"
  deletion_protection = false

  # Explaining: The service must wait for all secret versions to be initialized as PLACEHOLDERs.
  depends_on = [
    google_secret_manager_secret_version.secret_versions # [cite: 2, 40]
  ]

  template {
    # Explaining: Using app_sa as defined in your iam.tf.
    service_account = google_service_account.app_sa.email # [cite: 3, 19]

    scaling {
      min_instance_count = 1
      max_instance_count = 3
    }

    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.repository_id}/portfolio-app:latest" # [cite: 1, 2]

      startup_probe {
        http_get {
          path = "/api/health" # [cite: 4]
          port = 8080
        }
        initial_delay_seconds = 30
        period_seconds        = 10 # [cite: 4]
        failure_threshold     = 3
      }

      # Standard environment variables
      env {
        name  = "FIRESTORE_DB"
        value = "(default)" # [cite: 5]
      }

      # Explaining: Referencing secrets via the map created by for_each in secrets.tf.
      
      env {
        name = "GEMINI_API_KEY"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.secrets["GEMINI_API_KEY"].secret_id # [cite: 5, 39]
            version = "latest"
          }
        }
      }

      env {
        name = "QDRANT_API_KEY"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.secrets["QDRANT_API_KEY"].secret_id # [cite: 6, 39]
            version = "latest"
          }
        }
      }

      env {
        name = "ADMIN_SECRET"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.secrets["ADMIN_SECRET"].secret_id # [cite: 7, 39]
            version = "latest"
          }
        }
      }

      env {
        name = "RECAPTCHA_SECRET_KEY"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.secrets["RECAPTCHA_SECRET_KEY"].secret_id # [cite: 8, 39]
            version = "latest"
          }
        }
      }

      env {
        name = "SLACK_BOT_TOKEN"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.secrets["SLACK_BOT_TOKEN"].secret_id # [cite: 9, 39]
            version = "latest"
          }
        }
      }

      env {
        name = "SLACK_CHANNEL_ID"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.secrets["SLACK_CHANNEL_ID"].secret_id # [cite: 10, 39]
            version = "latest"
          }
        }
      }

      env {
        name = "SLACK_SIGNING_SECRET"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.secrets["SLACK_SIGNING_SECRET"].secret_id # [cite: 11, 39]
            version = "latest"
          }
        }
      }

      env {
        name = "LOKI_HOST"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.secrets["LOKI_HOST"].secret_id # [cite: 12, 39]
            version = "latest"
          }
        }
      }

      env {
        name = "LOKI_USERNAME"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.secrets["LOKI_USERNAME"].secret_id # [cite: 13, 39]
            version = "latest"
          }
        }
      }

      env {
        name = "LOKI_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.secrets["LOKI_PASSWORD"].secret_id # [cite: 14, 39]
            version = "latest"
          }
        }
      }

      env {
        name = "GRAFANA_METRICS_USER"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.secrets["GRAFANA_METRICS_USER"].secret_id # [cite: 15, 39]
            version = "latest"
          }
        }
      }

      env {
        name = "GRAFANA_METRICS_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.secrets["GRAFANA_METRICS_PASSWORD"].secret_id # [cite: 15, 39]
            version = "latest"
          }
        }
      }

      # Useme module secrets
      env {
        name = "GMAIL_CLIENT_ID"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.secrets["GMAIL_CLIENT_ID"].secret_id
            version = "latest"
          }
        }
      }

      env {
        name = "GMAIL_CLIENT_SECRET"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.secrets["GMAIL_CLIENT_SECRET"].secret_id
            version = "latest"
          }
        }
      }

      env {
        name = "GMAIL_REFRESH_TOKEN"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.secrets["GMAIL_REFRESH_TOKEN"].secret_id
            version = "latest"
          }
        }
      }

      env {
        name = "USEME_POLL_TOKEN"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.secrets["USEME_POLL_TOKEN"].secret_id
            version = "latest"
          }
        }
      }

      env {
        name = "USEME_USER_SKILLS"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.secrets["USEME_USER_SKILLS"].secret_id
            version = "latest"
          }
        }
      }

      env {
        name = "GRAFANA_REMOTE_WRITE_URL"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.secrets["GRAFANA_REMOTE_WRITE_URL"].secret_id
            version = "latest"
          }
        }
      }

      resources {
        limits = {
          cpu    = "1000m" # [cite: 16]
          memory = "1024Mi"
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      template[0].containers[0].image, # [cite: 17]
      client,
      client_version
    ]
  }
}

# --- Public Access ---
resource "google_cloud_run_service_iam_member" "public_access" {
  service  = google_cloud_run_v2_service.portfolio_app.name
  location = google_cloud_run_v2_service.portfolio_app.location
  role     = "roles/run.invoker" # [cite: 17]
  member   = "allUsers"
}

# --- Domain Mapping ---
resource "google_cloud_run_domain_mapping" "default" {
  location = var.region
  name     = "ks-infra.dev"

  metadata {
    namespace = var.project_id
  }

  spec {
    route_name = google_cloud_run_v2_service.portfolio_app.name
  }
}