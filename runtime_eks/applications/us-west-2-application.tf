module "application_us_west_2" {
  source = "./modules/fake-service"

  region        = "us-west-2"
  name          = "application"
  port          = local.service_ports.application
  upstream_uris = "http://database.virtual.consul"

  providers = {
    kubernetes = kubernetes.us_west_2
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
              "peer" = local.peers.us_east_1
            },
          ]
          "name" = "application"
        },
      ]
    }
  }

  provider = kubernetes.us_west_2
}

resource "kubernetes_manifest" "service_intentions_application_peered" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ServiceIntentions"
    "metadata" = {
      "name"      = "application"
      "namespace" = var.namespace
    }
    "spec" = {
      "destination" = {
        "name" = "application"
      }
      "sources" = [
        {
          "action" = "allow"
          "name"   = "web"
          "peer"   = local.peers.us_east_1
        },
      ]
    }
  }

  provider = kubernetes.us_west_2
}

resource "kubernetes_manifest" "service_resolver_database" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ServiceResolver"
    "metadata" = {
      "name"      = "database"
      "namespace" = var.namespace
    }
    "spec" = {
      "connectTimeout" = "5s"
      "failover" = {
        "*" = {
          "targets" = [
            {
              "peer" = local.peers.eu_west_1
            },
          ]
        }
      }
    }
  }

  provider = kubernetes.us_west_2
}