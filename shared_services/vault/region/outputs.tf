output "vault_token" {
  value       = vault_token.consul_ca.client_token
  description = "Vault token for Consul service mesh CA"
  sensitive   = true
}

output "pki_int_path" {
  value       = local.consul_int_pki_path
  description = "Vault PKI intermediate path"
}
