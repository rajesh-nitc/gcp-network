variable name {
}

variable health_check_port {
  default = "22"
}

# variable backends {
#   description = "Map backend indices to list of backend maps."
#   type = map(list(object({
#     group    = string
#     failover = bool
#   })))
# }

# variable subnetworks {
#   type = list(string)
# }

variable ip_address {
  default = null
}

variable ip_protocol {
  default = "TCP"
}
variable all_ports {
  type = bool
}
variable ports {
  type    = list(string)
  default = []
}

variable network {
  default = null
}

variable "subnet" {
  type        = string
}

variable "backend" {
  type        = string
}

variable "project_id" {
  type        = string
  description = "Project ID for Private Shared VPC."
}

variable "region" {
  type        = string
}