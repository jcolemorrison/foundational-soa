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