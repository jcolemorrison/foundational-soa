resource "boundary_host_catalog_static" "catalog" {
  name        = var.name_prefix
  description = var.description
  scope_id    = var.scope_id
}

resource "boundary_host_static" "host" {
  for_each        = var.target_ips
  type            = "static"
  name            = "${var.name_prefix}_${replace(each.value, ".", "_")}"
  description     = "${var.description} for ${var.name_prefix}"
  address         = each.value
  host_catalog_id = boundary_host_catalog_static.catalog.id
}

resource "boundary_host_set_static" "host_set" {
  type            = "static"
  name            = var.name_prefix
  description     = var.description
  host_catalog_id = boundary_host_catalog_static.catalog.id
  host_ids        = [for host in boundary_host_static.host : host.id]
}

resource "boundary_target" "target" {
  type                     = var.target_type
  name                     = var.name_prefix
  description              = var.description
  scope_id                 = var.scope_id
  ingress_worker_filter    = var.ingress_worker_filter
  egress_worker_filter     = var.egress_worker_filter
  session_connection_limit = var.session_connection_limit
  default_port             = var.default_port
  host_source_ids = [
    boundary_host_set_static.host_set.id
  ]
}
