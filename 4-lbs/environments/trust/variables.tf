variable "project_id" {
  type        = string
  description = "Project ID for Private Shared VPC."
}

variable "backend" {
  type = string
}

variable "network" {
  type = string
}

variable "network_self_link" {
  type = string
}

variable "subnet" {
  type = string
}

variable "region" {
  type = string
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
    port                = 22
    port_name           = null
    request             = null
    request_path        = null
    host                = null
  }
}

variable "terraform_service_account" {
  type = string
}