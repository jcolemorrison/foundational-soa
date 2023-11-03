output "boundary_worker_path" {
  value       = vault_mount.boundary_worker.path
  description = "Boundary worker secrets path in Vault"
}

output "boundary_worker_token" {
  value       = vault_token.boundary_worker.client_token
  sensitive   = true
  description = "Boundary worker token for Vault"
}