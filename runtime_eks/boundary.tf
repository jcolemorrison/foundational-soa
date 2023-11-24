resource "boundary_scope" "runtime_eks" {
  name                     = "runtime_eks"
  description              = "Project for EKS runtime"
  scope_id                 = local.boundary_org_scope_id
  auto_create_admin_role   = true
  auto_create_default_role = true
}

# resource "boundary_credential_store_vault" "database" {
#   name        = "vault"
#   description = "Vault credentials store for ${local.name}"
#   address     = data.terraform_remote_state.shared_services.outputs.hcp_us_east_1.vault.address
#   token       = vault_token.boundary_controller.client_token
#   namespace   = module.database_vault.namespace
#   scope_id    = boundary_scope.runtime_eks.id
# }

# module "boundary_database_target" {
#   source = "../modules/boundary/database"

#   db_name = module.us_east_1.database.dbname
#   db_host = module.us_east_1.database.address
#   db_port = module.us_east_1.database.port

#   boundary_scope_id                  = boundary_scope.runtime_eks.id
#   boundary_credentials_store_id      = boundary_credential_store_vault.database.id
#   vault_path_to_database_credentials = "${module.database_vault.static_secrets_path}/data/${module.us_east_1.database.dbname}-admin"
#   access_level                       = "write"

#   service               = local.name
#   ingress_worker_filter = "\"eks\" in \"/tags/type\" and \"${local.us_east_1}\" in \"/tags/type\""
#   egress_worker_filter  = "\"eks\" in \"/tags/type\" and \"${local.us_east_1}\" in \"/tags/type\""
# }
