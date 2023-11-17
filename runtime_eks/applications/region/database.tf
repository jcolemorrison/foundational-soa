module "database" {
  source = "../modules/fake-service"

  region        = var.region
  name          = "database"
  port          = local.service_ports.database
  upstream_uris = ""
  error_rate    = var.test_failover_database ? 100.0 : 0.0
}

resource "kubernetes_manifest" "service_intentions_database" {
  count = var.peer_for_database_failover != "" ? 0 : 1
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
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "service_intentions_database_peer" {
  count = var.peer_for_database_failover != "" ? 1 : 0
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
          }, {
          "action" = "allow"
          "name"   = "application"
          "peer"   = var.peer_for_database_failover
        },
      ]
    }
  }
}