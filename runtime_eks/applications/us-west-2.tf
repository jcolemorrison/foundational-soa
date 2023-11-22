module "fake_service_us_west_2" {
  source = "./region"

  region    = "us-west-2"
  namespace = var.namespace

  peers_for_failover = [local.peers.eu_west_1, local.peers.us_east_1]

  service_name = local.service_name

  vault_database_path        = local.vault_database.path
  vault_database_secret_role = local.vault_database.role

  providers = {
    kubernetes = kubernetes.us_west_2
    vault      = vault.us_west_2
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
          "name" = "application"
        },
      ]
    }
  }

  provider = kubernetes.us_west_2
}

resource "kubernetes_manifest" "service_resolver_application_to_database" {
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
