resource "vault_kubernetes_auth_backend_role" "database" {
  backend                          = var.vault_kubernetes_auth_path
  role_name                        = var.vault_database_secret_role
  bound_service_account_names      = [module.database.service_account_name]
  bound_service_account_namespaces = [var.namespace]
  token_ttl                        = 3600
  token_policies                   = [var.vault_database_secret_policy]
}
