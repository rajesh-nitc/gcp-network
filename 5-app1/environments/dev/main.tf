module "instance_template" {
  source             = "git@github.com:terraform-google-modules/terraform-google-vm.git//modules/instance_template?ref=v5.1.0"
  region             = var.region
  project_id         = var.project_id
  subnetwork         = var.subnet
  machine_type       = "f1-micro"
  enable_shielded_vm = true
  service_account = {
    email  = google_service_account.instance_sa.email
    scopes = ["cloud-platform"]
  }
  startup_script = "sudo yum -yq install httpd bind-utils && sudo systemctl enable httpd && sudo systemctl start httpd"
  #   tags           = ["allow-iap-ssh", "allow-google-apis", "egress-internet"]
}

module "compute_instance" {
  source            = "git@github.com:terraform-google-modules/terraform-google-vm.git//modules/compute_instance?ref=v5.1.0"
  # project      = var.project_id
  region            = var.region
  subnetwork        = var.subnet
  num_instances     = 1
  hostname          = "test-app1"
  instance_template = module.instance_template.self_link
}

resource "google_compute_instance_group" "umig" {
  name      = "umig-app1"
  project      = var.project_id
  zone      = "${var.region}-a"
  instances = [module.compute_instance.instances_self_links[0]]

  named_port {
    name = "http"
    port = "80"
  }

  lifecycle {
    create_before_destroy = true
  }
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

module "ilb_app1" {
  source       = "../../../4-lbs/modules/tcp-ilb"
  project_id      = var.project_id
   region = var.region
  name              = "app1"
  subnet      = var.subnet
  all_ports         = true
  ports             = []
  health_check_port = "80"
  network           = var.network

   backend = google_compute_instance_group.umig.self_link
  providers = {
    google = google-beta
  }
}