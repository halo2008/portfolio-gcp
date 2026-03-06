resource "google_firestore_database" "database" {
  project     = var.project_id
  name        = "(default)"
  location_id = var.region
  type        = "FIRESTORE_NATIVE"

  depends_on = [google_project_service.services]
}

# TTL policy for ephemeral_users - auto-delete after expiresAt
resource "google_firestore_field" "ephemeral_users_ttl" {
  project    = var.project_id
  database   = google_firestore_database.database.name
  collection = "ephemeral_users"
  field      = "expiresAt"

  ttl_config {}

  depends_on = [google_firestore_database.database]
}

# TTL policy for lab_usage - auto-delete after expiresAt
resource "google_firestore_field" "lab_usage_ttl" {
  project    = var.project_id
  database   = google_firestore_database.database.name
  collection = "lab_usage"
  field      = "expiresAt"

  ttl_config {}

  depends_on = [google_firestore_database.database]
}

# TTL policy for useme_processed_offers - auto-delete after 30 days
resource "google_firestore_field" "useme_processed_offers_ttl" {
  project    = var.project_id
  database   = google_firestore_database.database.name
  collection = "useme_processed_offers"
  field      = "expiresAt"

  ttl_config {}

  depends_on = [google_firestore_database.database]
}
