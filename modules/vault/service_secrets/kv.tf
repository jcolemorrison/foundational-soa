resource "vault_mount" "static" {
  namespace   = var.vault_namespace
  path        = "kv"
  type        = "kv"
  options     = { version = "2" }
  description = "For static secrets related to ${var.service}"
}

data "vault_policy_document" "static" {
  rule {
    path         = "${vault_mount.static.path}/data/*"
    capabilities = ["read"]
    description  = "Read static credentials in key-value store"
  }
}

resource "vault_policy" "static" {
  namespace = var.vault_namespace
  name      = "${var.service}-static-read"
  policy    = data.vault_policy_document.static.hcl
}
