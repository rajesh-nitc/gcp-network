locals {
  vpc_name                = "${var.environment_code}"
  network_name            = "vpc-${local.vpc_name}"
  private_googleapis_cidr = "199.36.153.8/30"
}

module "main" {
  source                                 = "terraform-google-modules/network/google"
  version                                = "~> 2.0"
  project_id                             = var.project_id
  network_name                           = local.network_name
  shared_vpc_host                        = var.enable_shared_vpc
  delete_default_internet_gateway_routes = var.delete_default_internet_gateway_routes

  subnets          = var.subnets
  secondary_ranges = var.secondary_ranges

  routes = concat(
    var.enable_private ?
    [
      {
        name              = "rt-${local.vpc_name}-1000-all-default-private-api"
        description       = "Route through IGW to allow private google api access."
        destination_range = local.private_googleapis_cidr
        next_hop_internet = true
        priority          = "1000"
      }
    ]
    : [],
    var.enable_nat ?
    [
      {
        name              = "rt-${local.vpc_name}-1000-egress-internet-default"
        description       = "Tag based route through IGW to access internet"
        destination_range = "0.0.0.0/0"
        tags              = "egress-internet"
        next_hop_internet = true
        priority          = "1000"
      }
    ]
    : [],
    var.windows_activation_enabled ?
    [{
      name              = "rt-${local.vpc_name}-1000-all-default-windows-kms"
      description       = "Route through IGW to allow Windows KMS activation for GCP."
      destination_range = "35.190.247.13/32"
      next_hop_internet = true
      priority          = "1000"
      }
    ]
    : []
  )
}

# Configure Service Networking for Cloud SQL & future services.
# resource "google_compute_global_address" "private_service_access_address" {
#   count         = var.environment_code == "untrust" || var.environment_code == "management" || var.environment_code == "trust" ? 0 : 1
#   name          = "ga-${local.vpc_name}-vpc-peering-internal"
#   project       = var.project_id
#   purpose       = "VPC_PEERING"
#   address_type  = "INTERNAL"
#   address       = element(split("/", var.private_service_cidr), 0)
#   prefix_length = element(split("/", var.private_service_cidr), 1)
#   network       = module.main.network_self_link
# }

# resource "google_service_networking_connection" "private_vpc_connection" {
#   count                   = var.environment_code == "untrust" || var.environment_code == "management" || var.environment_code == "trust" ? 0 : 1
#   network                 = module.main.network_self_link
#   service                 = "servicenetworking.googleapis.com"
#   reserved_peering_ranges = [google_compute_global_address.private_service_access_address[count.index].name]
# }
