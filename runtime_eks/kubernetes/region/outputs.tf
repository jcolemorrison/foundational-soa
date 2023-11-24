output "kubernetes_ca_cert" {
  value       = kubernetes_secret.vault_auth.data["ca.crt"]
  description = "Kubernetes cluster CA certificate"
  sensitive   = true
}

output "kubernetes_token" {
  value       = kubernetes_secret.vault_auth.data.token
  description = "Kubernetes cluster token"
  sensitive   = true
}