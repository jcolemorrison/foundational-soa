module "fake_service_us_east_1" {
  source = "./region"

  region                    = "us-east-1"
  namespace                 = var.namespace
  test_failover_application = false

  peers_for_failover = [local.peers.us_west_2, local.peers.eu_west_1]

  service_name = local.service_name

  vault_database_path        = local.vault_database.path
  vault_database_secret_role = local.vault_database.role

  vault_namespace = trimsuffix(local.vault_database.namespace, "/")

  providers = {
    kubernetes = kubernetes.us_east_1
    vault      = vault.us_east_1
    consul     = consul.us_east_1
  }
}

resource "kubernetes_manifest" "service_resolver_web_to_application" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ServiceResolver"
    "metadata" = {
      "name"      = "application"
      "namespace" = var.namespace
    }
    "spec" = {
      "connectTimeout" = "0s"
      "failover" = {
        "*" = {
          "samenessGroup" = module.fake_service_us_east_1.sameness_group
        }
      }
    }
  }

  provider = kubernetes.us_east_1
}
