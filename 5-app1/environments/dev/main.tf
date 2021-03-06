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
  ip_address        = "10.1.0.100"

  backend = google_compute_instance_group.umig.self_link
  providers = {
    google = google-beta
  }
}
