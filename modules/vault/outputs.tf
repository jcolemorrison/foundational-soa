output "namespace" {
  value       = vault_namespace.service.id
  description = "Service namespace in Vault"
}

output "static_secrets_path" {
  value = vault_mount.static.path
}

output "database_secrets_path" {
  value = var.db_name != null ? vault_mount.database.0.path : null
}

output "policies" {
  value = concat([
    vault_policy.static.name
  ], var.db_name != null ? vault_policy.database.0.name : [])
}