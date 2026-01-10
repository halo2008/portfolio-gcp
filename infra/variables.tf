# Variables.tf

variable "project_id" {
  type        = string
  description = "The unique GCP project ID where resources will be deployed"
  default     = "festive-dolphin-483819-i1"
}

variable "region" {
  type        = string
  description = "The GCP region for resource deployment (e.g., europe-central2 for Warsaw)"
  default     = "europe-west1"
}

variable "app_name" {
  type        = string
  description = "The application name used as a prefix for resource naming"
  default     = "ks-portfolio"
}