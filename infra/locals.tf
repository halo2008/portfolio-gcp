locals {
  github_repos = [
    "halo2008/portfolio-gcp",
    "halo2008/portfolio"
  ]

  common_tags = {
    managed_by  = "terraform"
    application = var.app_name
    environment = "production"
  }
}
