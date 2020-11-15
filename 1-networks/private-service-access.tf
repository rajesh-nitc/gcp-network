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
  depends_on              = [google_project_service.apis]
}
