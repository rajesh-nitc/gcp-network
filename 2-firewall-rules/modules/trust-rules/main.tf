locals {
  vpc_name                = "${var.environment_code}"
  network_name            = "vpc-${local.vpc_name}"
  private_googleapis_cidr = "199.36.153.8/30"
}

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