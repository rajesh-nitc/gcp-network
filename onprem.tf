module "vpc_onprem" {
  source                                 = "terraform-google-modules/network/google"
  version                                = "~> 2.0"
  project_id                             = var.onprem_project_id
  network_name                           = "vpc-onprem"
  shared_vpc_host                        = var.enable_shared_vpc
  delete_default_internet_gateway_routes = true

  subnets = [
    {
      subnet_name           = "sb-onprem-${var.default_region1}"
      subnet_ip             = var.onprem_default_region1_subnet_cidr
      subnet_region         = var.default_region1
      subnet_private_access = false
      subnet_flow_logs      = false
    }
  ]

  routes = [
    {
      name              = "default-for-forward-proxy"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "rtag-forward-proxy"
      next_hop_internet = true
      priority          = "100"
    },
    {
      name                   = "default-for-all"
      description            = "route through proxy"
      destination_range      = "0.0.0.0/0"
      next_hop_instance      = google_compute_instance.forward_proxy_instance.name
      next_hop_instance_zone = "${var.default_region1}-a"
    }
  ]

}

# onprem router
module "region1_router1_onprem" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 0.2.0"
  name    = "cr-onprem-${var.default_region1}-cr1"
  project = var.onprem_project_id
  network = module.vpc_onprem.network_name
  region  = var.default_region1
  bgp = {
    asn               = "64513"
    advertised_groups = ["ALL_SUBNETS"]
  }
}

# onprem firewall
resource "google_compute_firewall" "allow_iap_ssh_onprem" {
  name          = "fw-onprem-1000-i-a-all-allow-iap-ssh-tcp-22"
  network       = module.vpc_onprem.network_name
  project       = var.onprem_project_id
  source_ranges = concat(data.google_netblock_ip_ranges.iap_forwarders.cidr_blocks_ipv4)

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["allow-iap-ssh"]
}

resource "google_compute_firewall" "allow_internal" {
  name          = "fw-onprem-allow-internal"
  network       = module.vpc_onprem.network_name
  project       = var.onprem_project_id
  source_ranges = [var.onprem_default_region1_subnet_cidr]

  allow {
    protocol = "all"
  }

  target_tags = ["ntag-forward-proxy"]
}

# onprem dns
module "private_googleapis_onprem" {
  source      = "terraform-google-modules/cloud-dns/google"
  version     = "~> 3.0"
  project_id  = var.onprem_project_id
  type        = "private"
  name        = "dz-onprem-apis"
  domain      = "googleapis.com."
  description = "Private DNS zone to configure private.googleapis.com"

  private_visibility_config_networks = [
    module.vpc_onprem.network_self_link
  ]

  recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = ["private.googleapis.com."]
    },
    {
      name    = "private"
      type    = "A"
      ttl     = 300
      records = ["199.36.153.8", "199.36.153.9", "199.36.153.10", "199.36.153.11"]
    },
  ]
}

module "base_gcr_onprem" {
  source      = "terraform-google-modules/cloud-dns/google"
  version     = "~> 3.0"
  project_id  = var.onprem_project_id
  type        = "private"
  name        = "dz-onprem-gcr"
  domain      = "gcr.io."
  description = "Private DNS zone to configure gcr.io"

  private_visibility_config_networks = [
    module.vpc_onprem.network_self_link
  ]

  recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = ["gcr.io."]
    },
    {
      name    = ""
      type    = "A"
      ttl     = 300
      records = ["199.36.153.8", "199.36.153.9", "199.36.153.10", "199.36.153.11"]
    },
  ]
}

resource "google_dns_policy" "default_policy_onprem" {
  project                   = var.onprem_project_id
  name                      = "dp-onprem-default-policy"
  enable_inbound_forwarding = false
  enable_logging            = false
  networks {
    network_url = module.vpc_onprem.network_self_link
  }
}

# onprem test vm
module "instance_template_onprem" {
  source             = "git@github.com:terraform-google-modules/terraform-google-vm.git//modules/instance_template?ref=v5.1.0"
  region             = var.default_region1
  project_id         = var.onprem_project_id
  subnetwork         = element(module.vpc_onprem.subnets_self_links, 0)
  enable_shielded_vm = false
  service_account = {
    email  = google_service_account.instance_sa_onprem.email
    scopes = ["cloud-platform"]
  }
  tags = ["allow-iap-ssh"]
}

module "compute_instance_onprem" {
  source            = "git@github.com:terraform-google-modules/terraform-google-vm.git//modules/compute_instance?ref=v5.1.0"
  region            = var.default_region1
  subnetwork        = element(module.vpc_onprem.subnets_self_links, 0)
  num_instances     = 1
  hostname          = "test1"
  instance_template = module.instance_template_onprem.self_link
}

resource "google_service_account" "instance_sa_onprem" {
  project      = var.onprem_project_id
  account_id   = "compute-sa-onprem"
  display_name = "Service Account for Test Instance Onprem"
}

resource "google_project_iam_member" "instance_roles_onprem" {
  for_each = toset(var.service_account_roles)
  project  = var.onprem_project_id
  role     = each.key
  member   = "serviceAccount:${google_service_account.instance_sa_onprem.email}"
}

resource "google_project_iam_member" "instance_roles_on_gcp" {
  project = var.project_id
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.instance_sa_onprem.email}"
}

# onprem forward proxy vm
resource "google_compute_instance" "forward_proxy_instance" {
  boot_disk {
    auto_delete = true
    device_name = "forward-proxy-instance"

    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/debian-cloud/global/images/debian-9-stretch-v20190423"
      size  = "10"
      type  = "pd-standard"
    }
  }

  can_ip_forward      = true
  deletion_protection = false
  labels              = {}
  machine_type        = "n1-standard-1"
  metadata            = {}
  name                = "forward-proxy-instance"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    network    = module.vpc_onprem.network_self_link
    subnetwork = element(module.vpc_onprem.subnets_self_links, 0)
  }

  project                 = var.onprem_project_id
  metadata_startup_script = "iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE; sysctl -w net.ipv4.ip_forward=1"

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
  }

  tags = ["rtag-forward-proxy", "ntag-forward-proxy", "allow-iap-ssh"]
  zone = "${var.default_region1}-a"
}
