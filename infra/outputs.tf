# outputs.tf

output "registry_url" {
  description = "The URL of the Artifact Registry repository"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.repository_id}"
}

output "service_account_email" {
  description = "The email address of the application Service Account"
  value       = google_service_account.app_sa.email
}

output "wif_provider_name" {
  description = "Workload Identity Provider Name for GitHub Actions"
  value       = google_iam_workload_identity_pool_provider.github_provider.name
}

output "cloud_run_url" {
  description = "The URL of the deployed Cloud Run service"
  value       = google_cloud_run_v2_service.portfolio_app.uri
}