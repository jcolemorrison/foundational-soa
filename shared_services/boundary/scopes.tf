resource "boundary_scope" "org" {
  scope_id                 = "global"
  name                     = "prod"
  description              = "Production Boundary organization"
  auto_create_default_role = true
  auto_create_admin_role   = true
}