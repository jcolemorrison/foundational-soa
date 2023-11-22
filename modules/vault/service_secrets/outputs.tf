output "namespace" {
  value       = vault_namespace.service.id
  description = "Service namespace in Vault"
}

output "static_secrets_path" {
  value       = vault_mount.static.path
  description = "Path to secrets in key-value store, including database administrative password"
}

output "database_secrets_path" {
  value       = var.db_name != null ? vault_mount.database.0.path : null
  description = "Path to database credentials"
}

output "database_secrets_role" {
  value       = var.db_name != null ? vault_database_secret_backend_role.database.0.name : null
  description = "Vault role for database credentials"
}

output "policies" {
  value = concat([
    vault_policy.static.name
  ], var.db_name != null ? [vault_policy.database.0.name] : [])
  description = "List of Vault policies for static and dynamic secrets"
}
