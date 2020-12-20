module "untrust_rules" {
  source           = "../../modules/untrust-rules"
  project_id       = var.project_id
  environment_code = "untrust"
}

module "management_rules" {
  source           = "../../modules/mgmt-rules"
  project_id       = var.project_id
  environment_code = "management"
}

module "trust_rules" {
  source           = "../../modules/trust-rules"
  project_id       = var.project_id
  environment_code = "trust"
}

module "private_rules" {
  source           = "../../modules/private-rules"
  project_id       = var.project_id
  environment_code = "dev"
}