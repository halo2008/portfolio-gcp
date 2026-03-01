locals {
  github_repo = "halo2008/portfolio-gcp"

  common_tags = {
    managed_by  = "terraform"
    application = var.app_name
    environment = "production"
  }
}
