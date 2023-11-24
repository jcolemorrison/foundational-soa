resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
  path = "kubernetes/${var.region}"
}

resource "vault_kubernetes_auth_backend_config" "kubernetes" {
  backend                = vault_auth_backend.kubernetes.path
  kubernetes_host        = var.kubernetes_endpoint
  kubernetes_ca_cert     = var.kubernetes_ca_cert
  token_reviewer_jwt     = var.kubernetes_token
  disable_iss_validation = "true"
}
