resource "helm_release" "vault" {
  name             = "vault"
  namespace        = var.vault_namespace
  create_namespace = true

  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  version    = var.vault_helm_version

  set {
    name  = "injector.enabled"
    value = "true"
  }

  set {
    name  = "injector.externalVaultAddr"
    value = var.hcp_vault_private_address
  }
}

resource "helm_release" "vault_operator" {
  depends_on = [helm_release.vault]
  name       = "vault-secrets-operator"
  namespace  = var.vault_namespace

  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault-secrets-operator"
  version    = var.vault_operator_helm_version

  set {
    name  = "defaultVaultConnection.enabled"
    value = "true"
  }

  set {
    name  = "defaultVaultConnection.address"
    value = var.hcp_vault_private_address
  }
}

data "kubernetes_service_account" "vault_auth" {
  depends_on = [helm_release.vault]

  metadata {
    name      = "vault"
    namespace = helm_release.vault.namespace
  }
}

resource "kubernetes_secret" "vault_auth" {
  depends_on = [helm_release.vault]
  metadata {
    name      = "vault"
    namespace = helm_release.vault.namespace
    annotations = {
      "kubernetes.io/service-account.name"      = data.kubernetes_service_account.vault_auth.metadata.0.name
      "kubernetes.io/service-account.namespace" = data.kubernetes_service_account.vault_auth.metadata.0.namespace
    }
  }

  type = "kubernetes.io/service-account-token"
}

resource "vault_auth_backend" "kubernetes" {
  depends_on = [helm_release.vault]
  type       = "kubernetes"
  local      = true
}

resource "vault_kubernetes_auth_backend_config" "kubernetes" {
  depends_on             = [helm_release.vault]
  backend                = vault_auth_backend.kubernetes.path
  kubernetes_host        = var.kubernetes_endpoint
  kubernetes_ca_cert     = kubernetes_secret.vault_auth.data["ca.crt"]
  token_reviewer_jwt     = kubernetes_secret.vault_auth.data.token
  disable_iss_validation = "true"
}
