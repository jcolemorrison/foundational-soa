## Generate level-3 intermediate CA
resource "vault_mount" "consul_connect_pki_int" {
  namespace                 = var.namespace
  path                      = "${var.pki_int_path}/${local.region_suffix}"
  type                      = "pki"
  description               = "PKI engine hosting certificate for Consul service mesh (level 3 intermediate)"
  default_lease_ttl_seconds = var.validity_in_seconds
  max_lease_ttl_seconds     = var.validity_in_seconds
  local                     = true
}

resource "vault_pki_secret_backend_intermediate_cert_request" "consul_connect_pki_int" {
  namespace             = var.namespace
  backend               = vault_mount.consul_connect_pki_int.path
  type                  = "internal"
  common_name           = "Consul service mesh CA3 v1"
  key_type              = "rsa"
  key_bits              = "4096"
  add_basic_constraints = true
  exclude_cn_from_sans  = true
}

resource "vault_pki_secret_backend_root_sign_intermediate" "consul_connect_pki_int" {
  namespace            = var.namespace
  backend              = var.consul_connect_pki_path
  csr                  = vault_pki_secret_backend_intermediate_cert_request.consul_connect_pki_int.csr
  common_name          = "Consul service mesh CA3 v1.1"
  exclude_cn_from_sans = true
  max_path_length      = 1
  ttl                  = var.validity_in_seconds
}

resource "vault_pki_secret_backend_intermediate_set_signed" "consul_connect_pki_int" {
  namespace = var.namespace
  backend   = vault_mount.consul_connect_pki_int.path
  certificate = format(
    "%s\n%s",
    vault_pki_secret_backend_root_sign_intermediate.consul_connect_pki_int.certificate,
    var.certificate_chain
  )
}

## Create Vault policy to allow access to root certificate for Consul clusters
resource "vault_policy" "consul_ca_int" {
  namespace = var.namespace
  name      = "consul-ca-int-${var.region}"

  policy = <<EOT
path "/sys/mounts/${vault_mount.consul_connect_pki_int.path}" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

path "/sys/mounts/${vault_mount.consul_connect_pki_int.path}/tune" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

path "/${vault_mount.consul_connect_pki_int.path}/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

path "/${vault_mount.consul_connect_pki_int.path}/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}
EOT
}

resource "vault_token_auth_backend_role" "consul_ca" {
  namespace           = var.namespace
  role_name           = "consul-ca-${var.region}"
  allowed_policies    = [var.vault_policy_consul_ca, vault_policy.consul_ca_int.name]
  disallowed_policies = ["default"]
  orphan              = true
  token_period        = var.validity_in_seconds
  renewable           = true
  token_num_uses      = 0
}

resource "vault_token" "consul_ca" {
  namespace = var.namespace
  role_name = vault_token_auth_backend_role.consul_ca.role_name
  policies  = [var.vault_policy_consul_ca, vault_policy.consul_ca_int.name]
}