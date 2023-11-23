locals {
  vault_path = "prod-ecs"
}

resource "vault_namespace" "service" {
  path = local.vault_path

  provider = vault.admin
}

resource "vault_mount" "static" {
  namespace   = vault_namespace.service.path
  path        = "kv"
  type        = "kv"
  options     = { version = "2" }
  description = "For static secrets related to ${local.vault_path}"

  provider = vault.admin
}

data "vault_policy_document" "static" {
  rule {
    path         = "${vault_mount.static.path}/data/*"
    capabilities = ["read"]
    description  = "Read static credentials in key-value store"
  }

  provider = vault.admin
}

resource "vault_policy" "static" {
  namespace = vault_namespace.service.path
  name      = "${local.vault_path}-static-read"
  policy    = data.vault_policy_document.static.hcl

  provider = vault.admin
}

resource "random_string" "random" {
  length           = 16
  special          = false
  min_lower = 3
  min_upper = 3
}

resource "vault_kv_secret_v2" "api_key" {
  namespace           = vault_namespace.service.path
  mount               = vault_mount.static.path
  name                = "${local.vault_path}-api-key"
  delete_all_versions = true

  data_json = <<EOT
{
  "apikey": "${random_string.random.result}"
}
EOT

  provider = vault.admin
}