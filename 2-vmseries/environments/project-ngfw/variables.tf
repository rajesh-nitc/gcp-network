variable subnets {
  type = list(string)
}

variable fw_panos {
  type = string
}

variable fw_machine_type {
  type = string
}

variable "project_id" {
  type        = string
  description = "Project ID for Private Shared VPC."
}

variable tags {
  type    = list(string)
}

variable "terraform_service_account" {
  type        = string
}

variable "region" {
  type        = string
}