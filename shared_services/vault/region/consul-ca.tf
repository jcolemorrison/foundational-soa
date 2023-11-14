## Create Vault policy to allow access to root certificate for Consul clusters
resource "vault_policy" "consul_ca_int" {
  namespace = var.namespace
  name      = "consul-ca-int-${var.region}"

  policy = <<EOT
path "/sys/mounts/${local.consul_int_pki_path}" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

path "/sys/mounts/${local.consul_int_pki_path}/tune" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

path "/${local.consul_int_pki_path}/*" {
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
  renewable           = true
  token_num_uses      = 0
}

resource "vault_token" "consul_ca" {
  namespace = var.namespace
  role_name = vault_token_auth_backend_role.consul_ca.role_name
  policies  = [var.vault_policy_consul_ca, vault_policy.consul_ca_int.name]
}
