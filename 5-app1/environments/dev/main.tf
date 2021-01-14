# resource "google_compute_address" "ip_address" {
#   name = "external-ip"
# }

# locals {
#   access_config = {
#     nat_ip       = google_compute_address.ip_address.address
#     network_tier = "PREMIUM"
#   }
# }

# module "instance_template" {
#   source             = "git@github.com:terraform-google-modules/terraform-google-vm.git//modules/instance_template?ref=v5.1.0"
#   region             = var.region
#   project_id         = var.project_id
#   subnetwork         = var.subnet
#   # machine_type       = "f1-micro"
#   enable_shielded_vm = false
#   can_ip_forward     = true
#   service_account = {
#     email  = google_service_account.instance_sa.email
#     scopes = ["cloud-platform"]
#   }
#   startup_script = "sudo yum -yq install httpd bind-utils && sudo systemctl enable httpd && sudo systemctl start httpd"
#   #   tags           = ["allow-iap-ssh", "allow-google-apis", "egress-internet"]
#   # access_config   = [local.access_config]
# }

# module "compute_instance" {
#   source = "git@github.com:terraform-google-modules/terraform-google-vm.git//modules/compute_instance?ref=v5.1.0"
#   # project      = var.project_id
#   region            = var.region
#   subnetwork        = var.subnet
#   num_instances     = 1
#   hostname          = "app2"
#   instance_template = module.instance_template.self_link
# }

resource "google_compute_instance" "default" {
  name                      = "spoke1-vm"
  project                   = var.project_id
  machine_type              = "n1-standard-1"
  zone                      = "${var.region}-a"
  can_ip_forward            = true
  allow_stopping_for_update = true
  metadata_startup_script   = "apt-get update && apt-get install -y apache2 && systemctl restart apache2"

  metadata = {
    serial-port-enable = true
    # ssh-keys           = var.ssh_key
  }

  network_interface {
    subnetwork = var.subnet
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1604-lts"
    }
  }

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
    ]
  }
}


resource "google_compute_instance_group" "umig" {
  name      = "umig-app1"
  project   = var.project_id
  zone      = "${var.region}-a"
  instances = [google_compute_instance.default.self_link]

  named_port {
    name = "http"
    port = "80"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# resource "google_service_account" "instance_sa" {
#   project      = var.project_id
#   account_id   = var.service_account_name
#   display_name = "Service Account for Test Instance"
# }

# resource "google_project_iam_member" "instance_roles" {
#   for_each = toset(var.service_account_roles)
#   project  = var.project_id
#   role     = each.key
#   member   = "serviceAccount:${google_service_account.instance_sa.email}"
# }

module "ilb_app1" {
  source            = "../../../4-lbs/modules/tcp-ilb"
  project_id        = var.project_id
  region            = var.region
  name              = "spoke1-intlb"
  subnet            = var.subnet
  all_ports         = true
  ports             = []
  health_check_port = "80"
  network           = var.network
  ip_address = "10.1.0.100"

  backend = google_compute_instance_group.umig.self_link
  providers = {
    google = google-beta
  }
}
