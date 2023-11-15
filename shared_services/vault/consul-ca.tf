resource "vault_namespace" "consul" {
  path = "consul"
}

locals {
  consul_service_mesh_root_ca_path         = "connect/pki"
  consul_service_mesh_intermediate_ca_path = "connect/pki_int"
}

## Create Vault policy to allow access to root certificate for Consul clusters
resource "vault_policy" "consul_ca" {
  namespace = vault_namespace.consul.path
  name      = "consul-ca"

  policy = <<EOT
path "/sys/mounts/${local.consul_service_mesh_root_ca_path}" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

path "/${local.consul_service_mesh_root_ca_path}/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

path "auth/token/renew-self" {
  capabilities = [ "update" ]
}

path "auth/token/lookup-self" {
  capabilities = [ "read" ]
}
EOT
}

module "consul_ca_int_us_east_1" {
  source                 = "./region"
  vault_policy_consul_ca = vault_policy.consul_ca.name
  namespace              = vault_namespace.consul.path

  region = "us-east-1"

  consul_root_pki_path = local.consul_service_mesh_root_ca_path
  consul_int_pki_path  = local.consul_service_mesh_intermediate_ca_path

  providers = {
    vault = vault
  }
}

module "consul_ca_int_us_west_2" {
  source                 = "./region"
  vault_policy_consul_ca = vault_policy.consul_ca.name
  namespace              = vault_namespace.consul.path

  region = "us-west-2"

  consul_root_pki_path = local.consul_service_mesh_root_ca_path
  consul_int_pki_path  = local.consul_service_mesh_intermediate_ca_path

  providers = {
    vault = vault.us_west_2
  }
}

module "consul_ca_int_eu_west_1" {
  source                 = "./region"
  vault_policy_consul_ca = vault_policy.consul_ca.name
  namespace              = vault_namespace.consul.path

  region = "eu-west-1"

  consul_root_pki_path = local.consul_service_mesh_root_ca_path
  consul_int_pki_path  = local.consul_service_mesh_intermediate_ca_path

  providers = {
    vault = vault.eu_west_1
  }
}
