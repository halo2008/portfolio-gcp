resource "google_artifact_registry_repository" "repo" {
  location      = var.region
  repository_id = "${var.app_name}-repo"
  format        = "DOCKER"

  # SRE Best Practice: Automatyczne czyszczenie
  cleanup_policies {
    id     = "delete-old-images"
    action = "DELETE"
    condition {
      older_than = "14d" # Usuń wszystko starsze niż 14 dni
    }
  }

  cleanup_policies {
    id     = "keep-last-5"
    action = "KEEP"
    most_recent_versions {
      keep_count = 5 # Ale zawsze zachowaj 5 najnowszych wersji
    }
  }
}
