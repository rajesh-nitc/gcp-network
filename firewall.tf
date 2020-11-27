resource "google_compute_firewall" "allow_private_api_egress" {
  name      = "fw-${var.environment_code}-base-65534-e-a-allow-google-apis-all-tcp-443"
  network   = module.main.network_name
  project   = var.project_id
  direction = "EGRESS"
  priority  = 65534

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  destination_ranges = [local.private_googleapis_cidr]
  target_tags        = ["allow-google-apis"]
}

resource "google_compute_firewall" "allow_iap_ssh" {
  name          = "fw-${var.environment_code}-base-1000-i-a-all-allow-iap-ssh-tcp-22"
  network       = module.main.network_name
  project       = var.project_id
  source_ranges = concat(data.google_netblock_ip_ranges.iap_forwarders.cidr_blocks_ipv4)

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["allow-iap-ssh"]
}

resource "google_compute_firewall" "allow_iap_rdp" {
  name          = "fw-${var.environment_code}-base-1000-i-a-all-allow-iap-rdp-tcp-3389"
  network       = module.main.network_name
  project       = var.project_id
  source_ranges = concat(data.google_netblock_ip_ranges.iap_forwarders.cidr_blocks_ipv4)

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  target_tags = ["allow-iap-rdp"]
}

resource "google_compute_firewall" "allow_windows_activation" {
  name      = "fw-${var.environment_code}-base-0-e-a-allow-win-activation-all-tcp-1688"
  network   = module.main.network_name
  project   = var.project_id
  direction = "EGRESS"
  priority  = 0

  allow {
    protocol = "tcp"
    ports    = ["1688"]
  }

  destination_ranges = ["35.190.247.13/32"]
  target_tags        = ["allow-win-activation"]
}

resource "google_compute_firewall" "allow_lb" {
  name          = "fw-${var.environment_code}-base-1000-i-a-all-allow-lb-tcp-80-8080-443"
  network       = module.main.network_name
  project       = var.project_id
  source_ranges = concat(data.google_netblock_ip_ranges.health_checkers.cidr_blocks_ipv4, data.google_netblock_ip_ranges.legacy_health_checkers.cidr_blocks_ipv4)

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "443"]
  }

  target_tags = ["allow-lb"]
}

resource "google_compute_firewall" "allow_onprem" {
  name    = "fw-${var.environment_code}-base-1000-i-a-all-allow-onprem"
  network = module.main.network_name
  project = var.project_id

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "443", "22"]
  }

  source_ranges = [var.onprem_default_region1_subnet_cidr]
}
