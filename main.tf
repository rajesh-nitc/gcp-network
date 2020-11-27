locals {
  vpc_name                = "${var.environment_code}-base"
  network_name            = "vpc-${local.vpc_name}"
  private_googleapis_cidr = "199.36.153.8/30"
  private_service_cidr    = "10.0.176.0/20"
}

module "main" {
  source                                 = "terraform-google-modules/network/google"
  version                                = "~> 2.0"
  project_id                             = var.project_id
  network_name                           = local.network_name
  shared_vpc_host                        = var.shared_vpc_host
  delete_default_internet_gateway_routes = true

  subnets = [
    {
      subnet_name           = "sb-${var.environment_code}-base-${var.default_region1}"
      subnet_ip             = "10.0.128.0/21"
      subnet_region         = var.default_region1
      subnet_private_access = true
      subnet_flow_logs      = false
    },
    {
      subnet_name           = "sb-${var.environment_code}-base-${var.default_region2}"
      subnet_ip             = "10.0.136.0/21"
      subnet_region         = var.default_region2
      subnet_private_access = true
      subnet_flow_logs      = false
    }
  ]

  secondary_ranges = {
    "sb-${var.environment_code}-base-${var.default_region1}" = [
      {
        range_name    = "rn-${var.environment_code}-base-${var.default_region1}-gke-pod"
        ip_cidr_range = "192.168.96.0/19"
      },
      {
        range_name    = "rn-${var.environment_code}-base-${var.default_region1}-gke-svc"
        ip_cidr_range = "192.168.128.0/23"
      }
    ]
  }

  routes = concat(
    [{
      name              = "rt-${local.vpc_name}-1000-all-default-private-api"
      description       = "Route through IGW to allow private google api access."
      destination_range = local.private_googleapis_cidr
      next_hop_internet = "true"
      priority          = "1000"
    }],
    var.nat_enabled ?
    [
      {
        name              = "rt-${local.vpc_name}-1000-egress-internet-default"
        description       = "Tag based route through IGW to access internet"
        destination_range = "0.0.0.0/0"
        tags              = "egress-internet"
        next_hop_internet = "true"
        priority          = "1000"
      }
    ]
    : [],
    var.windows_activation_enabled ?
    [{
      name              = "rt-${local.vpc_name}-1000-all-default-windows-kms"
      description       = "Route through IGW to allow Windows KMS activation for GCP."
      destination_range = "35.190.247.13/32"
      next_hop_internet = "true"
      priority          = "1000"
      }
    ]
    : []
  )
}

# Configure Service Networking for Cloud SQL & future services
resource "google_compute_global_address" "private_service_access_address" {
  name          = "ga-${local.vpc_name}-vpc-peering-internal"
  project       = var.project_id
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = element(split("/", local.private_service_cidr), 0)
  prefix_length = element(split("/", local.private_service_cidr), 1)
  network       = module.main.network_self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = module.main.network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_access_address.name]
}

# Router to advertise shared VPC subnetworks and Google Private API
module "region1_router1" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 0.2.0"
  name    = "cr-${local.vpc_name}-${var.default_region1}-cr1"
  project = var.project_id
  network = module.main.network_name
  region  = var.default_region1
  bgp = {
    asn                  = "64514"
    advertised_groups    = ["ALL_SUBNETS"]
    advertised_ip_ranges = [{ range = local.private_googleapis_cidr }]
  }
}