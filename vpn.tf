module "vpn_ha-1" {
  source           = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version          = "~> 1.3.0"
  project_id       = var.project_id
  region           = var.default_region1
  network          = module.main.network_self_link
  name             = "gcp-to-onprem"
  peer_gcp_gateway = module.vpn_ha-2.self_link
  router_asn       = 64514
  router_name      = module.region1_router1.router.name
  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.1"
        asn     = 64513
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.1.2/30"
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = null
      shared_secret                   = ""
    }
    remote-1 = {
      bgp_peer = {
        address = "169.254.2.1"
        asn     = 64513
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.2.2/30"
      ike_version                     = 2
      vpn_gateway_interface           = 1
      peer_external_gateway_interface = null
      shared_secret                   = ""
    }
  }
}

module "vpn_ha-2" {
  source           = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version          = "~> 1.3.0"
  project_id       = var.onprem_project_id
  region           = var.default_region1
  network          = module.vpc_onprem.network_self_link
  name             = "onprem-to-gcp"
  router_asn       = 64513
  router_name      = module.region1_router1_onprem.router.name
  peer_gcp_gateway = module.vpn_ha-1.self_link
  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.2"
        asn     = 64514
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.1.1/30"
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = null
      shared_secret                   = module.vpn_ha-1.random_secret
    }
    remote-1 = {
      bgp_peer = {
        address = "169.254.2.2"
        asn     = 64514
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.2.1/30"
      ike_version                     = 2
      vpn_gateway_interface           = 1
      peer_external_gateway_interface = null
      shared_secret                   = module.vpn_ha-1.random_secret
    }
  }
}
