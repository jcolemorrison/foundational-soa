locals {
  seconds_in_90_days = 7776000
}

resource "vault_namespace" "consul" {
  path = "consul"
}

## Generate level-1 intermediate CA
resource "vault_mount" "consul_connect_root" {
  namespace                 = vault_namespace.consul.path
  path                      = "connect/root"
  type                      = "pki"
  description               = "PKI engine hosting intermediate Connect CA1 v1 for Consul"
  default_lease_ttl_seconds = local.seconds_in_90_days
  max_lease_ttl_seconds     = local.seconds_in_90_days * 2
}

resource "vault_pki_secret_backend_intermediate_cert_request" "consul_connect_root" {
  namespace   = vault_namespace.consul.path
  backend     = vault_mount.consul_connect_root.path
  type        = "internal"
  common_name = "consul.${var.certificate_common_name}"
  key_type    = "rsa"
  key_bits    = "4096"
}

resource "vault_pki_secret_backend_intermediate_set_signed" "consul_connect_root" {
  namespace = vault_namespace.consul.path
  backend   = vault_mount.consul_connect_root.path

  certificate = aws_acmpca_certificate.subordinate_level_1.certificate
}

## Generate level-2 intermediate CA
resource "vault_mount" "consul_connect_pki" {
  namespace                 = vault_namespace.consul.path
  path                      = "connect/pki"
  type                      = "pki"
  description               = "PKI engine hosting intermediate Connect CA2 v1 for Consul"
  default_lease_ttl_seconds = local.seconds_in_90_days
  max_lease_ttl_seconds     = local.seconds_in_90_days * 2
}

resource "vault_pki_secret_backend_intermediate_cert_request" "consul_connect_pki" {
  namespace   = vault_namespace.consul.path
  backend     = vault_mount.consul_connect_pki.path
  type        = "internal"
  common_name = "consul.${var.certificate_common_name} Consul Connect CA2 v1"
  key_type    = "rsa"
  key_bits    = "4096"
}

resource "vault_pki_secret_backend_intermediate_set_signed" "consul_connect_pki" {
  namespace   = vault_namespace.consul.path
  backend     = vault_mount.consul_connect_pki.path
  certificate = aws_acmpca_certificate.subordinate_level_2.certificate
}

## Generate level-3 intermediate CA
resource "vault_mount" "consul_connect_pki_int" {
  namespace                 = vault_namespace.consul.path
  path                      = "connect/pki_int"
  type                      = "pki"
  description               = "PKI engine hosting intermediate Connect CA3 v1 for Consul"
  default_lease_ttl_seconds = local.seconds_in_90_days
  max_lease_ttl_seconds     = local.seconds_in_90_days * 2
}

resource "vault_pki_secret_backend_intermediate_cert_request" "consul_connect_pki_int" {
  namespace   = vault_namespace.consul.path
  backend     = vault_mount.consul_connect_pki_int.path
  type        = "internal"
  common_name = "${var.certificate_common_name} Consul Connect CA3 v1"
  key_type    = "rsa"
  key_bits    = "4096"
}

resource "vault_pki_secret_backend_intermediate_set_signed" "consul_connect_pki_int" {
  namespace   = vault_namespace.consul.path
  backend     = vault_mount.consul_connect_pki_int.path
  certificate = aws_acmpca_certificate.subordinate_level_3.certificate
}

## Create Vault policy to allow access to root certificate for Consul clusters
resource "vault_policy" "consul_ca" {
  namespace = vault_namespace.consul.path
  name      = "consul-ca"

  policy = <<EOT
path "${vault_mount.consul_connect_pki.path}/root/sign-self-issued" {
  capabilities = [ "sudo", "update" ]
}

path "auth/token/renew-self" {
  capabilities = [ "update" ]
}

path "auth/token/lookup-self" {
  capabilities = [ "read" ]
}

path "/sys/mounts" {
  capabilities = [ "read" ]
}

path "/sys/mounts/${vault_mount.consul_connect_pki.path}" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

path "/sys/mounts/${vault_mount.consul_connect_pki_int.path}" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

path "/sys/mounts/${vault_mount.consul_connect_pki_int.path}/tune" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

path "/${vault_mount.consul_connect_pki.path}/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

path "/${vault_mount.consul_connect_pki_int.path}/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}
EOT
}

resource "vault_token_auth_backend_role" "consul_ca" {
  namespace           = vault_namespace.consul.path
  role_name           = "consul-ca"
  allowed_policies    = [vault_policy.consul_ca.name]
  disallowed_policies = ["default"]
  orphan              = true
  token_period        = local.seconds_in_90_days * 2
  renewable           = true
  token_num_uses      = 0
}

resource "vault_token" "consul_ca_us_east_1" {
  namespace = vault_namespace.consul.path
  role_name = vault_token_auth_backend_role.consul_ca.role_name
  policies  = [vault_policy.consul_ca.name]
}

resource "vault_token" "consul_ca_us_west_2" {
  namespace = vault_namespace.consul.path
  role_name = vault_token_auth_backend_role.consul_ca.role_name
  policies  = [vault_policy.consul_ca.name]

  provider = vault.us_west_2
}

resource "vault_token" "consul_ca_eu_west_1" {
  namespace = vault_namespace.consul.path
  role_name = vault_token_auth_backend_role.consul_ca.role_name
  policies  = [vault_policy.consul_ca.name]

  provider = vault.eu_west_1
}