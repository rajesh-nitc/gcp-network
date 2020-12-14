module "inbound" {
  source  = "GoogleCloudPlatform/lb-http/google"
  version = "~> 4.4"

  project           = var.project_id
  name              = "inbound"
  firewall_networks = []
  firewall_projects = []
  backends = {
    default = {
      protocol    = "HTTP"
      port        = 80
      port_name   = "http"
      timeout_sec = 10
      enable_cdn  = false

      health_check = {
        request_path = "/"
        port         = 80
      }

      log_config = {
        enable      = true
        sample_rate = 1.0
      }

      groups = [
        {
          group = var.backend
        },
      ]
    }
  }
}
