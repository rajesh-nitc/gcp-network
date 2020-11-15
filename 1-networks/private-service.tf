module "mysql_db" {
  source               = "git@github.com:terraform-google-modules/terraform-google-sql-db.git//modules/safer_mysql?ref=v4.3.0"
  name                 = "test-db-${var.environment_code}"
  random_instance_name = true
  project_id           = var.project_id
  deletion_protection  = false
  database_version     = "MYSQL_5_6"
  region               = var.default_region1
  zone                 = "us-central1-c"
  tier                 = "db-n1-standard-1"
  assign_public_ip     = false
  vpc_network          = module.main.network_self_link
  user_name            = "allow-cloudsqlproxy-only"
  db_name              = "sample"
  module_depends_on    = [google_service_networking_connection.private_vpc_connection]
}
