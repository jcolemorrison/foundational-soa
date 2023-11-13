output "vault_token" {
  value       = vault_token.consul_ca.client_token
  description = "Vault token for Consul service mesh CA"
  sensitive   = true
}

output "pki_int_path" {
  value       = vault_mount.consul_connect_pki_int.path
  description = "Vault PKI intermediate path"
}
