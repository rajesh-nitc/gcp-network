resource "google_compute_health_check" "default" {
  name    = var.name
  project = var.project_id

  tcp_health_check {
    port = var.health_check_port
  }
}
resource "google_compute_region_backend_service" "default" {
  name          = var.name
  region        = var.region
  project       = var.project_id
  health_checks = [google_compute_health_check.default.self_link]
  network       = var.network


  backend {
    group          = var.backend
    balancing_mode = "CONNECTION" # internal TCP/UDP load balancers only support the CONNECTION balancing mode
    failover       = false
  }
  session_affinity = "NONE"
}

resource "google_compute_forwarding_rule" "default" {
  project               = var.project_id
  region                = var.region
  name                  = "${var.name}-all"
  load_balancing_scheme = "INTERNAL"
  ip_address            = var.ip_address
  ip_protocol           = var.ip_protocol
  all_ports             = var.all_ports
  ports                 = var.ports
  subnetwork            = var.subnet
  backend_service       = google_compute_region_backend_service.default.self_link
}
