variable "bucket_name" {
}

# variable file_location {
# }

variable "config" {
  type    = list(string)
  default = []
}

variable "content" {
  type    = list(string)
  default = []
}

variable "license" {
  type    = list(string)
  default = []
}

variable "software" {
  default = []
}

variable "project_id" {
  type        = string
  description = "Project ID for Private Shared VPC."
}