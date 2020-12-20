# # Default DNS Policy.
# resource "google_dns_policy" "default_policy" {
#   project                   = var.project_id
#   name                      = "dp-${var.environment_code}-base-default-policy"
#   enable_inbound_forwarding = var.dns_enable_inbound_forwarding
#   enable_logging            = var.dns_enable_logging
#   networks {
#     network_url = module.main.network_self_link
#   }
# }

# # Private Google APIs DNS Zone & records.
# module "private_googleapis" {
#   source      = "terraform-google-modules/cloud-dns/google"
#   version     = "~> 3.0"
#   project_id  = var.project_id
#   type        = "private"
#   name        = "dz-${var.environment_code}-base-apis"
#   domain      = "googleapis.com."
#   description = "Private DNS zone to configure private.googleapis.com"

#   private_visibility_config_networks = [
#     module.main.network_self_link
#   ]

#   recordsets = [
#     {
#       name    = "*"
#       type    = "CNAME"
#       ttl     = 300
#       records = ["private.googleapis.com."]
#     },
#     {
#       name    = "private"
#       type    = "A"
#       ttl     = 300
#       records = ["199.36.153.8", "199.36.153.9", "199.36.153.10", "199.36.153.11"]
#     },
#   ]
# }

# # Private GCR DNS Zone & records.
# module "base_gcr" {
#   source      = "terraform-google-modules/cloud-dns/google"
#   version     = "~> 3.0"
#   project_id  = var.project_id
#   type        = "private"
#   name        = "dz-${var.environment_code}-base-gcr"
#   domain      = "gcr.io."
#   description = "Private DNS zone to configure gcr.io"

#   private_visibility_config_networks = [
#     module.main.network_self_link
#   ]

#   recordsets = [
#     {
#       name    = "*"
#       type    = "CNAME"
#       ttl     = 300
#       records = ["gcr.io."]
#     },
#     {
#       name    = ""
#       type    = "A"
#       ttl     = 300
#       records = ["199.36.153.8", "199.36.153.9", "199.36.153.10", "199.36.153.11"]
#     },
#   ]
# }
