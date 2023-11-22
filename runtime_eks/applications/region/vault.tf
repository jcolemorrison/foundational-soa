data "vault_policy_document" "database" {
  rule {
    path         = "${var.vault_database_path}/creds/${var.vault_database_secret_role}"
    capabilities = ["read"]
    description  = "get database credentials for ${var.vault_database_secret_role}"
  }
}

resource "vault_policy" "database" {
  name   = var.vault_database_secret_role
  policy = data.vault_policy_document.database.hcl
}

resource "vault_kubernetes_auth_backend_role" "database" {
  backend                          = var.vault_kubernetes_auth_path
  role_name                        = var.vault_database_secret_role
  bound_service_account_names      = [module.database.service_account_name]
  bound_service_account_namespaces = [var.namespace]
  token_ttl                        = 3600
  token_policies                   = [vault_policy.database.name]
}
