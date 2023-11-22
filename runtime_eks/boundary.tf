resource "boundary_scope" "runtime_eks" {
  name                     = "runtime_eks"
  description              = "Project for EKS runtime"
  scope_id                 = local.boundary_org_scope_id
  auto_create_admin_role   = true
  auto_create_default_role = true
}

# module "boundary_database_target" {
#   source = "../modules/boundary/database"

#   db_name = ""
#   db_host = ""
#   db_port = ""

#   boundary_scope_id                  = ""
#   boundary_credentials_store_id      = ""
#   vault_path_to_database_credentials = ""
#   access_level                       = "write"

#   service               = local.name
#   ingress_worker_filter = ""
#   egress_worker_filter  = ""
# }
