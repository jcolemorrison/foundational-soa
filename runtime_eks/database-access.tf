resource "vault_namespace" "database" {
  path     = local.name
  provider = vault.us_east_1
}

module "database_vault" {
  count  = module.us_east_1.database != null ? 1 : 0
  source = "../modules/vault/service_secrets"

  service         = local.name
  vault_namespace = vault_namespace.database.namespace

  db_name     = module.us_east_1.database.dbname
  db_username = module.us_east_1.database.username
  db_password = module.us_east_1.database.password
  db_address  = module.us_east_1.database.address
  db_port     = module.us_east_1.database.port

  providers = {
    vault = vault.us_east_1
  }
}

resource "vault_policy" "boundary_controller" {
  count     = module.us_east_1.database != null ? 1 : 0
  name      = "boundary-controller"
  namespace = vault_namespace.database.namespace
  policy    = <<EOT
path "auth/token/lookup-self" {
  capabilities = ["read"]
}

path "auth/token/renew-self" {
  capabilities = ["update"]
}

path "auth/token/revoke-self" {
  capabilities = ["update"]
}

path "sys/leases/renew" {
  capabilities = ["update"]
}

path "sys/leases/revoke" {
  capabilities = ["update"]
}

path "sys/capabilities-self" {
  capabilities = ["update"]
}
EOT

  provider = vault.us_east_1
}

resource "vault_token" "boundary_controller" {
  count             = module.us_east_1.database != null ? 1 : 0
  namespace         = local.name
  policies          = concat([vault_policy.boundary_controller.0.name], values(module.database_vault.0.database_secrets_policies))
  no_default_policy = true
  no_parent         = true
  ttl               = "60d"
  explicit_max_ttl  = "120d"
  period            = "30d"
  renewable         = true
  num_uses          = 0

  provider = vault.us_east_1
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
