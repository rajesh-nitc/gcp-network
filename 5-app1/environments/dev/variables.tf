variable "service_account_roles" {
  type = list(string)

  description = "List of IAM roles to assign to the service account."
  default = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/compute.osLogin",
  ]
}

variable "service_account_name" {
  type    = string
  default = "test-instance-sa"
}

variable "health_check" {
  default = {
    type                = "tcp"
    check_interval_sec  = 1
    healthy_threshold   = 4
    timeout_sec         = 1
    unhealthy_threshold = 5
    response            = ""
    proxy_header        = "NONE"
    port                = 80
    port_name           = null
    request             = null
    request_path        = null
    host                = null
  }
}

variable "project_id" {
  type        = string
  description = "Project ID for Private Shared VPC."
}

variable "region" {
  type = string
}

variable "subnet" {
  type = string
}

variable "network" {
  type = string
}

variable "terraform_service_account" {
  type = string
}
