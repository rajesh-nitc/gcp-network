variable "project_id" {
  type        = string
  description = "Project ID for Private Shared VPC."
}

variable "environment_code" {
  type        = string
  description = "A short form of the folder level resources (environment) within the Google Cloud organization."
}

variable "default_region1" {
  type        = string
  description = "Default region 1 for subnets and Cloud Routers"
  default     = ""
}

variable "default_region2" {
  type        = string
  description = "Default region 2 for subnets and Cloud Routers"
  default     = ""
}

variable "enable_nat" {
  type = bool
}

variable "enable_shared_vpc" {
  type = bool
}

variable "nat_bgp_asn" {
  type        = number
  description = "BGP ASN for first NAT cloud routes."
  default     = 0
}

variable "nat_num_addresses_region1" {
  type        = number
  description = "Number of external IPs to reserve for first Cloud NAT."
  default     = 2
}

variable "nat_num_addresses_region2" {
  type        = number
  description = "Number of external IPs to reserve for second Cloud NAT."
  default     = 2
}

variable "bgp_asn_subnet" {
  type        = number
  description = "BGP ASN for Subnets cloud routers."
  default     = 0
}

variable "subnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
  default     = []
}

variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default     = {}
}

variable "dns_enable_inbound_forwarding" {
  type        = bool
  description = "Toggle inbound query forwarding for VPC DNS."
  default     = true
}

variable "dns_enable_logging" {
  type        = bool
  description = "Toggle DNS logging for VPC DNS."
  default     = true
}

variable "firewall_enable_logging" {
  type        = bool
  description = "Toggle firewall logging for VPC Firewalls."
  default     = true
}

variable "private_service_cidr" {
  type        = string
  description = "CIDR range for private service networking. Used for Cloud SQL and other managed services."
  default     = ""
}

variable "windows_activation_enabled" {
  type        = bool
  description = "Enable Windows license activation for Windows workloads."
  default     = false
}

variable "nat_num_addresses" {
  type        = number
  description = "Number of external IPs to reserve for Cloud NAT."
  default     = 2
}

variable "delete_default_internet_gateway_routes" {
  type    = bool
  default = true
}

variable "enable_private" {
  type    = bool
  default = true
}
