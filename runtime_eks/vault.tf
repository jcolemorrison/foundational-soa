module "database_vault" {
  source      = "../modules/vault/service_secrets"
  service     = local.name
  db_name     = module.us_east_1.database.dbname
  db_username = module.us_east_1.database.username
  db_password = module.us_east_1.database.password
  db_address  = module.us_east_1.database.address
  db_port     = module.us_east_1.database.port

  providers = {
    vault = vault.admin
  }
}

resource "vault_policy" "boundary_controller" {
  name      = "boundary-controller"
  namespace = local.name
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

  provider = vault.admin
}

resource "vault_policy" "database" {
  name      = "${local.name}-database"
  namespace = local.name
  policy    = <<EOT
path "${module.database_vault.static_secrets_path}/data/*" {
  capabilities = ["read"]
}

path "${module.database_vault.database_secrets_path}/creds/*" {
  capabilities = ["read"]
}
EOT

  provider = vault.admin
}

resource "vault_token" "boundary_controller" {
  namespace         = local.name
  policies          = [vault_policy.boundary_controller.name, vault_policy.database.id]
  no_default_policy = true
  no_parent         = true
  ttl               = "60d"
  explicit_max_ttl  = "120d"
  period            = "30d"
  renewable         = true
  num_uses          = 0

  provider = vault.admin
}
