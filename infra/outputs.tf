# outputs.tf

output "registry_url" {
  description = "The URL of the Artifact Registry repository"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.repository_id}"
}

output "service_account_email" {
  description = "The email address of the application Service Account"
  value       = google_service_account.app_sa.email
}

output "github_actions_private_key" {
  description = "Sensitive JSON Key for GitHub Actions (Add to Secrets as GCP_SA_KEY)"
  value       = google_service_account_key.github_actions_key.private_key
  sensitive   = true
}