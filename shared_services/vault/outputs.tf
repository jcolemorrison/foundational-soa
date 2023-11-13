output "boundary_worker_namespace" {
  value       = vault_namespace.boundary.id
  description = "Boundary namespace in Vault"
}

output "boundary_worker_path" {
  value       = vault_mount.boundary_worker.path
  description = "Boundary worker secrets path in Vault"
}

output "boundary_worker_token" {
  value = {
    "us_east_1" = vault_token.boundary_worker_us_east_1.client_token
    "us_west_2" = vault_token.boundary_worker_us_west_2.client_token
    "eu_west_1" = vault_token.boundary_worker_eu_west_1.client_token
  }
  sensitive   = true
  description = "Boundary worker tokens for Vault"
}

output "consul_ca" {
  value = {
    "us_east_1" = {
      namespace    = vault_namespace.consul.id
      pki_path     = vault_mount.consul_connect_pki.path
      pki_int_path = module.consul_ca_int_us_east_1.pki_int_path
      token        = module.consul_ca_int_us_east_1.vault_token
    }
  }
  sensitive   = true
  description = "Consul service mesh CA worker tokens for Vault"
}
