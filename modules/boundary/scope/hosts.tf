resource "boundary_host_catalog_static" "catalog" {
  name        = var.name_prefix
  description = var.description
  scope_id    = boundary_scope.runtime.id
}

resource "boundary_host_static" "host" {
  for_each        = var.target_ips
  type            = "static"
  name            = "${var.name_prefix}_${each.value}"
  description     = "${var.description} for ${var.name_prefix}"
  address         = each.key
  host_catalog_id = boundary_host_catalog_static.catalog.id
}

resource "boundary_host_set_static" "host_set" {
  type            = "static"
  name            = var.name_prefix
  description     = var.description
  host_catalog_id = boundary_host_catalog_static.catalog.id
  host_ids        = [for host in boundary_host_static.host : host.id]
}