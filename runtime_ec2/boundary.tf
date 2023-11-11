resource "boundary_scope" "runtime_ec2" {
  name                     = "runtime_ec2"
  description              = "Project for EC2 runtime"
  scope_id                 = local.boundary_org_scope_id
  auto_create_admin_role   = true
  auto_create_default_role = true
}