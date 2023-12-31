module "customers" {
  source = "../modules/fake-service"

  region        = var.region
  name          = "customers"
  port          = local.service_ports.customers
  upstream_uris = "http://database.virtual.consul"
  error_rate    = var.test_failover_customers ? 100.0 : 0.0
}

resource "kubernetes_manifest" "service_intentions_customers" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ServiceIntentions"
    "metadata" = {
      "name"      = "customers"
      "namespace" = var.namespace
    }
    "spec" = {
      "destination" = {
        "name" = "customers"
      }
      "sources" = [
        {
          "action" = "allow"
          "name"   = "store"
        },
        {
          "action"        = "allow"
          "name"          = "store"
          "samenessGroup" = var.sameness_group_name
        },
      ]
    }
  }
}