resource "vault_namespace" "consul" {
  path = "consul"
}

## Generate level-2 intermediate CA
resource "vault_mount" "consul_connect_pki" {
  namespace                 = vault_namespace.consul.path
  path                      = "connect/pki"
  type                      = "pki"
  description               = "PKI engine hosting certificate for Consul service mesh (level 2 intermediate)"
  default_lease_ttl_seconds = local.validity_in_seconds
  max_lease_ttl_seconds     = local.validity_in_seconds
}

resource "vault_pki_secret_backend_intermediate_cert_request" "consul_connect_pki" {
  namespace             = vault_namespace.consul.path
  backend               = vault_mount.consul_connect_pki.path
  type                  = "internal"
  common_name           = "prod.${var.certificate_common_name} Consul service mesh CA2 v1"
  key_type              = "rsa"
  key_bits              = "4096"
  add_basic_constraints = true
  exclude_cn_from_sans  = true
}

resource "vault_pki_secret_backend_root_sign_intermediate" "consul_connect_pki" {
  namespace       = vault_namespace.consul.path
  backend         = vault_mount.pki_level1.path
  csr             = vault_pki_secret_backend_intermediate_cert_request.consul_connect_pki.csr
  common_name     = "prod.${var.certificate_common_name} Consul service mesh CA2 v1.1"
  max_path_length = 1
}

resource "vault_pki_secret_backend_intermediate_set_signed" "consul_connect_pki" {
  namespace = vault_namespace.consul.path
  backend   = vault_mount.consul_connect_pki.path
  certificate = format(
    "%s\n%s",
    vault_pki_secret_backend_root_sign_intermediate.consul_connect_pki.certificate,
    aws_acmpca_certificate.subordinate.certificate_chain
  )
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

path "/${vault_mount.consul_connect_pki.path}/root/sign-intermediate" {
  capabilities = [ "update" ]
}

path "/${vault_mount.consul_connect_pki.path}/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}
EOT
}

module "consul_ca_int_us_east_1" {
  source                  = "./region"
  vault_policy_consul_ca  = vault_policy.consul_ca.name
  namespace               = vault_namespace.consul.path
  validity_in_seconds     = local.validity_in_seconds
  region                  = "us-east-1"
  pki_int_path            = "connect/pki_int"
  consul_connect_pki_path = vault_mount.consul_connect_pki.path

  certificate_chain = vault_pki_secret_backend_intermediate_set_signed.consul_connect_pki.certificate

  providers = {
    vault = vault
  }
}

module "consul_ca_int_us_west_2" {
  source                  = "./region"
  vault_policy_consul_ca  = vault_policy.consul_ca.name
  namespace               = vault_namespace.consul.path
  validity_in_seconds     = local.validity_in_seconds
  region                  = "us-west-2"
  pki_int_path            = "connect/pki_int"
  consul_connect_pki_path = vault_mount.consul_connect_pki.path

  certificate_chain = vault_pki_secret_backend_intermediate_set_signed.consul_connect_pki.certificate

  providers = {
    vault = vault.us_west_2
  }
}

module "consul_ca_int_eu_west_1" {
  source                  = "./region"
  vault_policy_consul_ca  = vault_policy.consul_ca.name
  namespace               = vault_namespace.consul.path
  validity_in_seconds     = local.validity_in_seconds
  region                  = "eu-west-1"
  pki_int_path            = "connect/pki_int"
  consul_connect_pki_path = vault_mount.consul_connect_pki.path

  certificate_chain = vault_pki_secret_backend_intermediate_set_signed.consul_connect_pki.certificate

  providers = {
    vault = vault.eu_west_1
  }
}