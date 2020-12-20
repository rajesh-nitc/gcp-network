module "untrust" {
  source                                 = "../../modules/vpc"
  project_id                             = var.project_id
  environment_code                       = "untrust"
  enable_nat                             = false
  enable_shared_vpc                      = false
  delete_default_internet_gateway_routes = false
  enable_private                         = false

  subnets = [
    {
      subnet_name           = "sb-untrust-${var.region}"
      subnet_ip             = var.subnet_untrust
      subnet_region         = var.region
      subnet_private_access = false
      subnet_flow_logs      = true
      description           = "First subnet example."
    }
  ]
}

module "management" {
  source                                 = "../../modules/vpc"
  project_id                             = var.project_id
  environment_code                       = "management"
  enable_nat                             = false
  enable_shared_vpc                      = false
  delete_default_internet_gateway_routes = false

  subnets = [
    {
      subnet_name           = "sb-management-${var.region}"
      subnet_ip             = var.subnet_mgmt
      subnet_region         = var.region
      subnet_private_access = false
      subnet_flow_logs      = true
      description           = "First subnet example."
    }
  ]
}

module "trust" {
  source                                 = "../../modules/vpc"
  project_id                             = var.project_id
  environment_code                       = "trust"
  enable_nat                             = false
  enable_shared_vpc                      = false
  delete_default_internet_gateway_routes = true

  subnets = [
    {
      subnet_name           = "sb-trust-${var.region}"
      subnet_ip             = var.subnet_trust
      subnet_region         = var.region
      subnet_private_access = false
      subnet_flow_logs      = true
      description           = "First subnet example."
    }
  ]
}

module "dev" {
  source                                 = "../../modules/vpc"
  project_id                             = var.project_id
  environment_code                       = "dev"
  enable_nat                             = false
  enable_shared_vpc                      = false
  delete_default_internet_gateway_routes = true

  subnets = [
    {
      subnet_name           = "sb-dev-${var.region}"
      subnet_ip             = var.subnet_dev
      subnet_region         = var.region
      subnet_private_access = false
      subnet_flow_logs      = true
      description           = "First subnet example."
    }
  ]
}
