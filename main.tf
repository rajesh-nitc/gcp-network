locals {
  vpc_name                = "${var.environment_code}-base"
  network_name            = "vpc-${local.vpc_name}"
  private_googleapis_cidr = "199.36.153.8/30"
}

module "main" {
  source                                 = "terraform-google-modules/network/google"
  version                                = "~> 2.0"
  project_id                             = var.project_id
  network_name                           = local.network_name
  shared_vpc_host                        = false
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
