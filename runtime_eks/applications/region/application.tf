module "application" {
  source = "../modules/fake-service"

  region        = var.region
  name          = "application"
  port          = local.service_ports.application
  upstream_uris = "http://database.virtual.consul"
  error_rate    = var.test_failover_application ? 100.0 : 0.0
}

resource "kubernetes_manifest" "service_intentions_application" {
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
          "action"        = "allow"
          "name"          = "web"
          "samenessGroup" = var.sameness_group_name
        },
      ]
    }
  }
}
