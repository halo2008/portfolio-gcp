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
