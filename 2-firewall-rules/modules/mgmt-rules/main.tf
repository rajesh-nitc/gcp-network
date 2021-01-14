locals {
  vpc_name                = var.environment_code
  network_name            = "vpc-${local.vpc_name}"
  private_googleapis_cidr = "199.36.153.8/30"
}

resource "google_compute_firewall" "allow" {
  name          = "fw-${var.environment_code}-i-a-22-443"
  network       = local.network_name
  project       = var.project_id
  source_ranges = ["0.0.0.0/0"]

  allow {
    # protocol = "tcp"
    # ports    = ["22", "443"]
    protocol = "all"
    ports    = []
  }

  # target_tags = ["ntag-test"]
}
