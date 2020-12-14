terraform {
  required_version = ">= 0.12"
}

provider "google" {
  # impersonate_service_account = var.terraform_service_account
}

provider "google-beta" {
  # impersonate_service_account = var.terraform_service_account
}
