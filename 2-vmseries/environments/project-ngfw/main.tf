module "bootstrap_common" {
  source      = "../../modules/gcp_bootstrap"
  project_id  = var.project_id
  bucket_name = "fw-bootstrap-common"
  config      = ["init-cfg.txt", "bootstrap.xml"]
  license     = ["authcodes"]
}

module "vmseries" {
  source              = "../../modules/vmseries"
  project_id          = var.project_id
  subnetworks         = var.subnets
  region              = var.region
  machine_type        = var.fw_machine_type
  bootstrap_bucket    = module.bootstrap_common.bucket_name
  mgmt_interface_swap = "enable"
  image               = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-${var.fw_panos}"
  nic0_public_ip      = true
  nic1_public_ip      = true
  nic2_public_ip      = false
  tags                = var.tags

  dependencies = [
    module.bootstrap_common.completion,
  ]
}
