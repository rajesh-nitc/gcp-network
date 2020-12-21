resource "null_resource" "dependency_getter" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies)}"
  }
}

resource "google_compute_instance" "vmseries" {
  name                      = "vmseries1"
  project                   = var.project_id
  machine_type              = var.machine_type
  zone                      = "${var.region}-a"
  min_cpu_platform          = var.cpu_platform
  can_ip_forward            = true
  allow_stopping_for_update = true
  tags                      = var.tags

  metadata = {
    mgmt-interface-swap                  = var.mgmt_interface_swap
    vmseries-bootstrap-gce-storagebucket = var.bootstrap_bucket
    serial-port-enable                   = true
  }

  service_account {
    scopes = var.scopes
  }

  network_interface {

    dynamic "access_config" {
      for_each = var.nic0_public_ip ? [""] : []
      content {}
    }
    subnetwork = var.subnetworks[0]
  }

  network_interface {
    dynamic "access_config" {
      for_each = var.nic1_public_ip ? [""] : []
      content {}
    }
    subnetwork = var.subnetworks[1]
  }

  network_interface {
    dynamic "access_config" {
      for_each = var.nic2_public_ip ? [""] : []
      content {}
    }
    subnetwork = var.subnetworks[2]
  }

  boot_disk {
    initialize_params {
      image = var.image
      type  = var.disk_type
    }
  }

  depends_on = [
    null_resource.dependency_getter
  ]
}

resource "google_compute_instance_group" "vmseries" {
  name      = "umig-vmseries"
  project   = var.project_id
  zone      = "${var.region}-a"
  instances = [google_compute_instance.vmseries.self_link]

  named_port {
    name = "http"
    port = "80"
  }

  lifecycle {
    create_before_destroy = true
  }
}

