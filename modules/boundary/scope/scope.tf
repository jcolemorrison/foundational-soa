resource "boundary_scope" "runtime" {
  name                     = var.scope_name
  description              = var.scope_description
  scope_id                 = var.org_scope_id
  auto_create_admin_role   = true
  auto_create_default_role = true
}