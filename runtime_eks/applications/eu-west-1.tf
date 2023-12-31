module "fake_service_eu_west_1" {
  source = "./region"

  region    = "eu-west-1"
  namespace = var.namespace

  enable_payments_service = true
  enable_inventory_v2     = true

  peers_for_failover = [local.peers.us_east_1, local.peers.us_west_2, local.peers.eu_west_1]

  service_name = local.service_name

  vault_database_path          = local.vault_database.path
  vault_database_secret_role   = local.vault_database.role
  vault_database_secret_policy = local.vault_database.policy
  vault_kubernetes_auth_path   = local.vault_kubernetes_auth_path.eu_west_1

  vault_namespace = trimsuffix(local.vault_database.namespace, "/")

  certificate_arn   = local.certificate_arns.eu_west_1
  public_subnet_ids = local.public_subnet_ids.eu_west_1

  providers = {
    kubernetes = kubernetes.eu_west_1
    vault      = vault.us_east_1
    consul     = consul.eu_west_1
  }
}
