resource "boundary_scope" "runtime_eks" {
  name                     = "runtime_eks"
  description              = "Project for EKS runtime"
  scope_id                 = local.boundary_org_scope_id
  auto_create_admin_role   = true
  auto_create_default_role = true
}