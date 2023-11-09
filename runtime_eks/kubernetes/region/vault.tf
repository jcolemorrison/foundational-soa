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
  depends_on       = [helm_release.vault]
  name             = "vault-secrets-operator"
  namespace        = var.vault_namespace
  create_namespace = true

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