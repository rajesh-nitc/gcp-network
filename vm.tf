module "instance_template" {
  source             = "git@github.com:terraform-google-modules/terraform-google-vm.git//modules/instance_template?ref=v5.1.0"
  region             = var.default_region1
  project_id         = var.project_id
  subnetwork         = element(module.main.subnets_self_links, 0)
  enable_shielded_vm = true
  service_account = {
    email  = google_service_account.instance_sa.email
    scopes = ["cloud-platform"]
  }
  startup_script = "sudo yum -yq install httpd bind-utils && sudo systemctl enable httpd && sudo systemctl start httpd"
  tags           = ["allow-iap-ssh", "allow-google-apis", "egress-internet"]
}

module "compute_instance" {
  source            = "git@github.com:terraform-google-modules/terraform-google-vm.git//modules/compute_instance?ref=v5.1.0"
  region            = var.default_region1
  subnetwork        = element(module.main.subnets_self_links, 0)
  num_instances     = 1
  hostname          = "vm-${var.environment_code}"
  instance_template = module.instance_template.self_link
}

resource "google_service_account" "instance_sa" {
  project      = var.project_id
  account_id   = var.service_account_name
  display_name = "Service Account for Test Instance"
}

resource "google_project_iam_member" "instance_roles" {
  for_each = toset(var.service_account_roles)
  project  = var.project_id
  role     = each.key
  member   = "serviceAccount:${google_service_account.instance_sa.email}"
}

