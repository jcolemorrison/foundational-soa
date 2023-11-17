module "application" {
  source = "../modules/fake-service"

  region        = var.region
  name          = "application"
  port          = local.service_ports.application
  upstream_uris = "http://database.virtual.consul"
  error_rate    = var.test_failover_application ? 100.0 : 0.0
}

resource "kubernetes_manifest" "service_intentions_application" {
  count = var.peer_for_application_failover != "" ? 0 : 1
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
      "sources" = concat([
        {
          "action" = "allow"
          "name"   = "web"
        },
      ])
    }
  }
}

resource "kubernetes_manifest" "service_intentions_application_peered" {
  count = var.peer_for_application_failover != "" ? 1 : 0
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
        },
        {
          "action" = "allow"
          "name"   = "web"
          "peer"   = var.peer_for_application_failover
        },
      ]
    }
  }
}
