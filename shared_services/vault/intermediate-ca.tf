locals {
  validity_in_days    = 180
  validity_in_seconds = 24 * 60 * 60 * local.validity_in_days
}

# Generate level-1 intermediate CA
resource "vault_mount" "pki_level1" {
  namespace                 = vault_namespace.consul.path
  path                      = "pki/level1"
  type                      = "pki"
  description               = "PKI engine hosting intermediate CA1 for root CA in ACM"
  default_lease_ttl_seconds = local.validity_in_seconds
  max_lease_ttl_seconds     = local.validity_in_seconds * 2
}

resource "vault_pki_secret_backend_intermediate_cert_request" "pki_level1" {
  namespace             = vault_namespace.consul.path
  backend               = vault_mount.pki_level1.path
  type                  = "internal"
  common_name           = "prod.${var.certificate_common_name}"
  key_type              = "rsa"
  key_bits              = "4096"
  add_basic_constraints = true
  exclude_cn_from_sans  = true
}

resource "vault_pki_secret_backend_intermediate_set_signed" "pki_level1" {
  namespace = vault_namespace.consul.path
  backend   = vault_mount.pki_level1.path

  certificate = aws_acmpca_certificate.subordinate.certificate_chain
}
