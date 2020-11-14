variable "environment_code" {
    type = string
}

variable "project_id" {
    type = string
}

variable "default_region1" {
    type = string
}

variable "default_region2" {
    type = string
}

variable "nat_enabled" {
    type = string
    default = true
}

variable "windows_activation_enabled" {
    type = string
    default = true
}

variable "nat_num_addresses_region1" {
  type        = number
  description = "Number of external IPs to reserve for first Cloud NAT."
  default     = 2
}

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
    type = string
    default = "test-instance-sa"
}

variable "project_services" {
  type = list

  default = [
    "servicenetworking.googleapis.com"
  ]

  description = ""
}
