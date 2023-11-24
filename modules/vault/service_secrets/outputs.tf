output "static_secrets_path" {
  value       = vault_mount.static.path
  description = "Path to secrets in key-value store, including database administrative password"
}

output "static_secrets_policy" {
  value       = vault_policy.static.name
  description = "Name of Vault policy that allows access to all static secrets for service"
}

output "database_secrets_path" {
  value       = var.db_name != null ? vault_mount.database.0.path : null
  description = "Path to database credentials"
}

output "database_secrets_role" {
  value       = var.db_name != null ? vault_database_secret_backend_role.database.0.name : null
  description = "Vault role for database credentials"
}

locals {
  database_polices = var.db_password != null ? {
    admin = vault_policy.database_admin.0.name
    read  = vault_policy.database.0.name
    } : var.db_name != null ? {
    read = vault_policy.database.0.name
  } : null
}

output "database_secrets_policies" {
  value       = local.database_polices
  description = "Name of Vault policies that allows admin or read access to database secrets engine for service"
}
