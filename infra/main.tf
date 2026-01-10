# main.tf

# Enable necessary GCP APIs
resource "google_project_service" "services" {
  for_each = toset([
    "run.googleapis.com",
    "artifactregistry.googleapis.com",
    "aiplatform.googleapis.com",
    "secretmanager.googleapis.com",
    "firestore.googleapis.com",
    "cloudbuild.googleapis.com"
  ])
  service = each.value
  disable_on_destroy = false
}

# Artifact Registry for Docker images
resource "google_artifact_registry_repository" "repo" {
  depends_on    = [google_project_service.services]
  location      = var.region
  repository_id = "${var.app_name}-repo"
  format        = "DOCKER"
  description   = "Docker repository for KS Portfolio application images"
}

# Service Account for Cloud Run execution
resource "google_service_account" "app_sa" {
  account_id   = "${var.app_name}-runner"
  display_name = "Service Account for ${var.app_name} Cloud Run services"
}

# Grant Vertex AI access to the Service Account
resource "google_project_iam_member" "vertex_ai_access" {
  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}

# Secret Manager for Qdrant API Key
resource "google_secret_manager_secret" "qdrant_key" {
  depends_on = [google_project_service.services]
  secret_id  = "QDRANT_API_KEY"

  replication {
    auto {}
    # user_managed {
    #   replicas {
    #     location = var.region
    #   }
    # }
  }
}

# Grant Secret Manager accessor role to the Service Account
resource "google_project_iam_member" "secret_access" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}

resource "google_cloud_run_v2_service" "portfolio_app" {
  name     = var.app_name
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"
  deletion_protection = false

  template {
    service_account = google_service_account.app_sa.email

    scaling {
      min_instance_count = 1
      max_instance_count = 2
    }

    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.repository_id}/portfolio-app:latest"

      resources {
        limits = {
          cpu    = "1000m"
          memory = "512Mi"
        }
        cpu_idle = true
      }

      # Zmienne środowiskowe
      env {
        name = "QDRANT_API_KEY"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.qdrant_key.secret_id
            version = "latest"
          }
        }
      }

      # Healthcheck (Ważne dla Load Balancera)
      startup_probe {
        http_get {
          path = "/"
          port = 8080
        }
        initial_delay_seconds = 5
        timeout_seconds = 2
        period_seconds = 5
        failure_threshold = 3
      }
    }
  }

  # Zezwolenie na ruch publiczny (bez logowania Google)
  depends_on = [google_project_service.services]
}

# Uprawnienie "allUsers" (Publiczny dostęp)
resource "google_cloud_run_service_iam_member" "public_access" {
  service  = google_cloud_run_v2_service.portfolio_app.name
  location = google_cloud_run_v2_service.portfolio_app.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# main.tf - dodaj to gdzieś pod resource "google_secret_manager_secret"

resource "google_secret_manager_secret_version" "qdrant_key_version" {
  secret = google_secret_manager_secret.qdrant_key.id

  # Tu wpisz swój klucz.
  # Uwaga: To zostanie zapisane w pliku stanu.
  # W przyszłości zmienimy to na zmienną, ale teraz musimy "przepchnąć" deployment.
  secret_data = "WKLEJ_TU_SWOJ_KLUCZ_API_DO_QDRANTA"
}


# ====================
# GitHub Actions setup
# ====================

# 1. Dedykowane konto serwisowe dla GitHub Actions
resource "google_service_account" "github_actions" {
  account_id   = "github-deployer"
  display_name = "GitHub Actions Deployer"
  description  = "Service Account used by GitHub Actions to push Docker images and deploy Cloud Run"
}

# 2. Uprawnienia: Pozwól mu wysyłać obrazy do Artifact Registry
resource "google_project_iam_member" "github_ar_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

# 3. Uprawnienia: Pozwól mu zarządzać Cloud Run (tworzyć nowe rewizje)
resource "google_project_iam_member" "github_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

# 4. Uprawnienia: Pozwól mu "udawać" konto runtime (app_sa)
# Jest to konieczne, bo Cloud Run musi uruchomić się jako "app_sa",
# więc GitHub musi mieć prawo powiedzieć "uruchom to jako app_sa".
resource "google_service_account_iam_member" "github_act_as_app_sa" {
  service_account_id = google_service_account.app_sa.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.github_actions.email}"
}

# 5. Generowanie klucza JSON (To zastępuje klikanie w konsoli)
resource "google_service_account_key" "github_actions_key" {
  service_account_id = google_service_account.github_actions.name
}