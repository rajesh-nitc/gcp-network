module "outbound" {
  source       = "GoogleCloudPlatform/lb-internal/google"
  version      = "~> 2.0"
  project      = var.project_id
  region       = var.region
  name         = "outbound"
  network      = var.network
  subnetwork   = var.subnet
  ports        = ["80"]
  health_check = var.health_check
  source_tags  = ["test"]
  target_tags  = ["test"]
  backends = [
    { group = var.backend, description = "" },
  ]
}

module "eastwest" {
  source       = "GoogleCloudPlatform/lb-internal/google"
  version      = "~> 2.0"
  project      = var.project_id
  region       = var.region
  name         = "eastwest"
  network      = var.network
  subnetwork   = var.subnet
  ports        = ["80"]
  health_check = var.health_check
  source_tags  = ["test"]
  target_tags  = ["test"]
  backends = [
    { group = var.backend, description = "" },
  ]
}

# Routes will be exported to private vpcs via peering
resource "google_compute_route" "outbound" {
  name         = "rt-ilb-outbound"
  project      = var.project_id
  dest_range   = "0.0.0.0/0"
  network      = var.network_self_link
  next_hop_ilb = module.outbound.forwarding_rule
  priority     = 100
  provider     = google-beta
}

resource "google_compute_route" "eastwest" {
  name         = "rt-ilb-eastwest"
  project      = var.project_id
  dest_range   = "10.0.0.0/8"
  network      = var.network_self_link
  next_hop_ilb = module.eastwest.forwarding_rule
  priority     = 100
  provider     = google-beta
}
