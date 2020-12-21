module "outbound" {
  source     = "../../modules/tcp-ilb"
  project_id = var.project_id
  region     = var.region
  name       = "outbound"
  subnet     = var.subnet

  all_ports         = true
  ports             = []
  health_check_port = "22"
  network           = var.network

  backend = var.backend
  providers = {
    google = google-beta
  }
}

module "eastwest" {
  source            = "../../modules/tcp-ilb"
  project_id        = var.project_id
  region            = var.region
  name              = "ew"
  subnet            = var.subnet
  all_ports         = true
  ports             = []
  health_check_port = "22"
  network           = var.network

  backend = var.backend
  providers = {
    google = google-beta
  }
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

# 
resource "google_compute_network_peering" "trust_to_spoke1" {
  name                 = "test1-test2" # "${var.trust_vpc}-to-${var.spoke1_vpc}"
  provider             = google-beta
  network              = var.network_self_link
  peer_network         = "https://www.googleapis.com/compute/v1/projects/ngfw-299010/global/networks/vpc-dev"
  export_custom_routes = true
}

resource "google_compute_network_peering" "spoke1_to_trust" {
  name                 = "test2-test1" #"${var.spoke1_vpc}-to-${var.trust_vpc}"
  provider             = google-beta
  network              = "https://www.googleapis.com/compute/v1/projects/ngfw-299010/global/networks/vpc-dev"
  peer_network         = var.network_self_link
  import_custom_routes = true

  depends_on = [google_compute_network_peering.trust_to_spoke1]
}
