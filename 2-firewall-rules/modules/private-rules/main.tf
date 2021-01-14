locals {
  vpc_name                = var.environment_code
  network_name            = "vpc-${local.vpc_name}"
  private_googleapis_cidr = "199.36.153.8/30"
}

# resource "google_compute_firewall" "allow_private_api_egress" {
#   name      = "fw-${var.environment_code}-base-65534-e-a-allow-google-apis-all-tcp-443"
#   network   = local.network_name
#   project   = var.project_id
#   direction = "EGRESS"
#   priority  = 65534

#   allow {
#     protocol = "tcp"
#     ports    = ["443"]
#   }

#   destination_ranges = [local.private_googleapis_cidr]
#   target_tags        = ["ntag-google-apis"]
# }

# resource "google_compute_firewall" "allow_iap_ssh" {
#   name          = "fw-${var.environment_code}-base-1000-i-a-all-allow-iap-ssh-tcp-22"
#   network       = local.network_name
#   project       = var.project_id
#   source_ranges = concat(data.google_netblock_ip_ranges.iap_forwarders.cidr_blocks_ipv4)

#   allow {
#     protocol = "tcp"
#     ports    = ["22"]
#   }

#   target_tags = ["ntag-iap-ssh"]
# }

# resource "google_compute_firewall" "allow_lb" {
#   name          = "fw-${var.environment_code}-base-1000-i-a-all-allow-lb-tcp-80-8080-443"
#   network       = local.network_name
#   project       = var.project_id
#   source_ranges = concat(data.google_netblock_ip_ranges.health_checkers.cidr_blocks_ipv4, data.google_netblock_ip_ranges.legacy_health_checkers.cidr_blocks_ipv4)

#   allow {
#     protocol = "tcp"
#     ports    = ["80", "8080", "443"]
#   }

#   target_tags = ["ntag-lb"]
# }

resource "google_compute_firewall" "allow_all" {
  name      = "fw-${var.environment_code}-i-a-all"
  network   = local.network_name
  project   = var.project_id
  priority  = 65534
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "all"
    ports    = []
  }
}
