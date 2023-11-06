resource "boundary_scope" "org" {
  scope_id                 = "global"
  name                     = "prod"
  description              = "Production Boundary organization"
  auto_create_default_role = true
  auto_create_admin_role   = true
}

## Create a project for each runtime
resource "boundary_scope" "runtime_eks" {
  name                     = "runtime_eks"
  description              = "EKS runtime"
  scope_id                 = boundary_scope.org.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}

resource "boundary_scope" "runtime_ecs" {
  name                     = "runtime_ecs"
  description              = "ECS runtime"
  scope_id                 = boundary_scope.org.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}

resource "boundary_scope" "runtime_ec2" {
  name                     = "runtime_ec2"
  description              = "EC2 runtime"
  scope_id                 = boundary_scope.org.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}