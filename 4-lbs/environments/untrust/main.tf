# module "inbound" {
#   source  = "GoogleCloudPlatform/lb-http/google"
#   version = "~> 4.4"

#   project           = var.project_id
#   name              = "inbound"
#   firewall_networks = []
#   firewall_projects = []
#   backends = {
#     default = {
#       description            = null
#       protocol               = "HTTP"
#       port                   = "80"
#       port_name              = "http"
#       timeout_sec            = null
#       enable_cdn             = false
#       custom_request_headers = null
#       security_policy        = null

#       connection_draining_timeout_sec = null
#       session_affinity                = null
#       affinity_cookie_ttl_sec         = null

#       health_check = {
#         check_interval_sec  = null
#         timeout_sec         = null
#         healthy_threshold   = null
#         unhealthy_threshold = null
#         request_path        = null
#         port                = "80"
#         host                = null
#         logging             = null
#       }

#       log_config = {
#         enable      = true
#         sample_rate = 1.0
#       }

#       groups = [
#         {
#           group                        = var.backend
#           balancing_mode               = "CONNECTION"
#           capacity_scaler              = null
#           description                  = null
#           max_connections              = null
#           max_connections_per_instance = null
#           max_connections_per_endpoint = null
#           max_rate                     = null
#           max_rate_per_instance        = null
#           max_rate_per_endpoint        = null
#           max_utilization              = null
#         },
#       ]

#       iap_config = {
#         enable               = false
#         oauth2_client_id     = null
#         oauth2_client_secret = null
#       }
#     }
#   }
# }

resource "google_compute_forwarding_rule" "default" {
  project               = var.project_id
  name                  = "extlb-fw-rule"
  target                = google_compute_target_pool.default.self_link
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  region                = var.region
  ip_address            = null
  ip_protocol           = "TCP"
}

resource "google_compute_target_pool" "default" {
  project          = var.project_id
  name             = "extlb-target-pool"
  region           = var.region
  session_affinity = "NONE"
  instances        = var.instances
  health_checks    = [google_compute_http_health_check.default.self_link]
}

resource "google_compute_http_health_check" "default" {
  project = var.project_id
  name    = "extlb-hc"

  check_interval_sec  = null
  healthy_threshold   = null
  timeout_sec         = null
  unhealthy_threshold = null

  port         = 80
  request_path = null
  host         = null
}

# module "load_balancer" {
#   source       = "GoogleCloudPlatform/lb/google"
#   version      = "~> 2.0.0"
#   region       = "us-east4"
#   name         = "load-balancer"
#   service_port = 443
#   network      = "vpc-"
# }