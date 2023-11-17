module "database_eu_west_1" {
  source = "./modules/fake-service"

  region        = "eu-west-1"
  name          = "database"
  port          = local.service_ports.database
  upstream_uris = ""

  providers = {
    kubernetes = kubernetes.eu_west_1
  }
}

resource "kubernetes_manifest" "exported_services_default_eu_west_1" {
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
              "peer" = local.peers.us_west_2
            },
          ]
          "name" = "database"
        },
      ]
    }
  }


  provider = kubernetes.eu_west_1
}

resource "kubernetes_manifest" "service_intentions_database_peered" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ServiceIntentions"
    "metadata" = {
      "name"      = "database"
      "namespace" = var.namespace
    }
    "spec" = {
      "destination" = {
        "name" = "database"
      }
      "sources" = [
        {
          "action" = "allow"
          "name"   = "application"
          "peer"   = local.peers.us_west_2
        },
      ]
    }
  }

  provider = kubernetes.eu_west_1
}
