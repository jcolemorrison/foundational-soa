resource "boundary_scope" "org" {
  scope_id                 = "global"
  name                     = "prod"
  description              = "Production Boundary organization"
  auto_create_default_role = true
  auto_create_admin_role   = true
}

## Create a project for each runtime
resource "boundary_scope" "" {
  name                     = "runtime_eks"
  description              = "EKS runtime"
  scope_id                 = boundary_scope.org.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}