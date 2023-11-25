locals {
  name = "database-admin-${var.db_name}"
}

resource "boundary_target" "database" {
  type                     = "tcp"
  name                     = local.name
  description              = "${var.access_level} access to ${var.db_name} database for ${var.service}"
  scope_id                 = var.boundary_scope_id
  ingress_worker_filter    = var.ingress_worker_filter
  egress_worker_filter     = var.egress_worker_filter
  session_connection_limit = -1
  default_port             = var.db_port
  host_source_ids = [
    boundary_host_set_static.database.id
  ]
  brokered_credential_source_ids = [
    boundary_credential_library_vault.database.id
  ]
}

resource "boundary_credential_library_vault" "database" {
  name                = local.name
  description         = "Credential library for ${var.access_level} access to ${var.db_name} database for ${var.service}"
  credential_store_id = var.boundary_credentials_store_id
  path                = var.vault_path_to_database_credentials
  http_method         = "GET"
  credential_type     = "username_password"
}
