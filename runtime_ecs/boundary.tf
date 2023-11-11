resource "boundary_scope" "runtime_ecs" {
  name                     = "runtime_ecs"
  description              = "Project for ECS runtime"
  scope_id                 = local.boundary_org_scope_id
  auto_create_admin_role   = true
  auto_create_default_role = true
}