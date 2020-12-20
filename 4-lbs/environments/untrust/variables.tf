variable "project_id" {
  type        = string
  description = "Project ID for Private Shared VPC."
}

variable "region" {
  type        = string
}

variable "instances" {
  type        = list(string)
}

variable "backend" {
  type        = string
}

variable "terraform_service_account" {
  type        = string
}

