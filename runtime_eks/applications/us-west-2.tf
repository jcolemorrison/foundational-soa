module "fake_service_us_west_2" {
  source = "./region"

  region    = "us-west-2"
  namespace = var.namespace

  peers_for_failover = [local.peers.eu_west_1, local.peers.us_east_1]

  service_name = local.service_name

  vault_database_path          = local.vault_database.path
  vault_database_secret_role   = local.vault_database.role
  vault_database_secret_policy = local.vault_database.policy
  vault_kubernetes_auth_path   = local.vault_kubernetes_auth_path.us_west_2

  vault_namespace = trimsuffix(local.vault_database.namespace, "/")

  providers = {
    kubernetes = kubernetes.us_west_2
    vault      = vault.us_east_1
    consul     = consul.us_west_2
  }
}
