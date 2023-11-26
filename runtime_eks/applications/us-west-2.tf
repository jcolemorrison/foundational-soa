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

resource "kubernetes_manifest" "exported_services_default_us_west_2" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ExportedServices"
    "metadata" = {
      "name"      = "default"
      "namespace" = var.namespace
    }
    "spec" = {
      "services" = [
        {
          "consumers" = [
            {
              "samenessGroup" = module.fake_service_us_west_2.sameness_group
            },
          ]
          "name" = "customers"
        },
      ]
    }
  }

  provider = kubernetes.us_west_2
}

resource "kubernetes_manifest" "service_resolver_customers_to_database" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ServiceResolver"
    "metadata" = {
      "name"      = "database"
      "namespace" = var.namespace
    }
    "spec" = {
      "connectTimeout" = "0s"
      "failover" = {
        "*" = {
          "samenessGroup" = module.fake_service_us_west_2.sameness_group
        }
      }
    }
  }

  provider = kubernetes.us_west_2
}
