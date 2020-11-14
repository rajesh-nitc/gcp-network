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
