locals {
  seconds_in_1_year  = 31536000
  seconds_in_3_years = 94608000
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
  default_lease_ttl_seconds = local.seconds_in_1_year
  max_lease_ttl_seconds     = local.seconds_in_3_years
}

resource "vault_pki_secret_backend_intermediate_cert_request" "consul_connect_root" {
  depends_on  = [vault_mount.consul_connect_root]
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

  certificate = aws_acmpca_certificate.subordinate.certificate
}

## Generate level-2 intermediate CA
resource "vault_mount" "consul_connect_pki" {
  namespace                 = vault_namespace.consul.path
  path                      = "connect/pki"
  type                      = "pki"
  description               = "PKI engine hosting intermediate Connect CA2 v1 for Consul"
  default_lease_ttl_seconds = local.seconds_in_1_year
  max_lease_ttl_seconds     = local.seconds_in_3_years
}

resource "vault_pki_secret_backend_intermediate_cert_request" "consul_connect_pki" {
  depends_on  = [vault_mount.consul_connect_pki]
  namespace   = vault_namespace.consul.path
  backend     = vault_mount.consul_connect_pki.path
  type        = "internal"
  common_name = "Consul Connect CA2 v1"
  key_type    = "rsa"
  key_bits    = "4096"
}

resource "vault_pki_secret_backend_root_sign_intermediate" "consul_connect_pki" {
  depends_on = [
    vault_mount.consul_connect_root,
    vault_pki_secret_backend_intermediate_cert_request.consul_connect_pki,
  ]
  namespace            = vault_namespace.consul.path
  backend              = vault_mount.consul_connect_root.path
  csr                  = vault_pki_secret_backend_intermediate_cert_request.consul_connect_pki.csr
  common_name          = "Consul Connect CA2 v1.1"
  exclude_cn_from_sans = true
  max_path_length      = 1
  ttl                  = local.seconds_in_1_year
}

resource "vault_pki_secret_backend_intermediate_set_signed" "consul_connect_pki" {
  depends_on = [vault_pki_secret_backend_root_sign_intermediate.consul_connect_pki]
  namespace  = vault_namespace.consul.path
  backend    = vault_mount.consul_connect_pki.path
  certificate = format(
    "%s\n%s",
    vault_pki_secret_backend_root_sign_intermediate.consul_connect_pki.certificate,
    aws_acmpca_certificate.subordinate.certificate
  )
}

## Generate level-3 intermediate CA
resource "vault_mount" "consul_connect_pki_int" {
  namespace                 = vault_namespace.consul.path
  path                      = "consul/connect/pki_int"
  type                      = "pki"
  description               = "PKI engine hosting intermediate Connect CA3 v1 for Consul"
  default_lease_ttl_seconds = local.seconds_in_1_year
  max_lease_ttl_seconds     = local.seconds_in_3_years
}

resource "vault_pki_secret_backend_intermediate_cert_request" "consul_connect_pki_int" {
  depends_on  = [vault_mount.consul_connect_pki_int]
  namespace   = vault_namespace.consul.path
  backend     = vault_mount.consul_connect_pki_int.path
  type        = "internal"
  common_name = "Consul Connect CA3 v1"
  key_type    = "rsa"
  key_bits    = "4096"
}

resource "vault_pki_secret_backend_root_sign_intermediate" "consul_connect_pki_int" {
  namespace = vault_namespace.consul.path
  depends_on = [
    vault_mount.consul_connect_pki,
    vault_pki_secret_backend_intermediate_cert_request.consul_connect_pki_int,
  ]
  backend              = vault_mount.consul_connect_pki.path
  csr                  = vault_pki_secret_backend_intermediate_cert_request.consul_connect_pki_int.csr
  common_name          = "Consul Connect CA3 v1.1"
  exclude_cn_from_sans = true
  max_path_length      = 1
  ttl                  = local.seconds_in_1_year
}

resource "vault_pki_secret_backend_intermediate_set_signed" "consul_connect_pki_int" {
  namespace  = vault_namespace.consul.path
  depends_on = [vault_pki_secret_backend_root_sign_intermediate.consul_connect_pki_int]
  backend    = vault_mount.consul_connect_pki_int.path
  certificate = format(
    "%s\n%s\n%s",
    vault_pki_secret_backend_root_sign_intermediate.consul_connect_pki_int.certificate,
    vault_pki_secret_backend_root_sign_intermediate.consul_connect_pki.certificate,
    aws_acmpca_certificate.subordinate.certificate
  )
}
