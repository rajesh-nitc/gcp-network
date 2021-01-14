locals {
  vpc_name                = var.environment_code
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
