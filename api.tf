resource "google_project_service" "apis" {
  for_each           = toset(var.project_services)
  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
}
