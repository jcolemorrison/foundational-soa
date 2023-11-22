resource "boundary_host_catalog_static" "database" {
  name        = local.name
  description = "${var.db_name} database for ${var.service}"
  scope_id    = var.boundary_scope_id
}

resource "boundary_host_static" "database" {
  type            = "static"
  name            = local.name
  description     = "${var.db_name} database for ${var.service}"
  address         = var.db_host
  host_catalog_id = boundary_host_catalog_static.database.id
}

resource "boundary_host_set_static" "database" {
  type            = "static"
  name            = local.name
  description     = "${var.db_name} database for ${var.service}"
  host_catalog_id = boundary_host_catalog_static.database.id
  host_ids        = [boundary_host_static.database.id]
}