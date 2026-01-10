# provider.tf
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.7.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "7.7.0"
    }
  }
  backend "gcs" {
    bucket = "festive-dolphin-483819-i1-tfstate"
    prefix = "terraform/state"
  }
}


provider "google" {
  project = var.project_id
  region = var.region
}