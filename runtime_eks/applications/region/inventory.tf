module "inventory" {
  source = "../modules/fake-service"

  region        = var.region
  name          = "inventory"
  port          = local.service_ports.inventory
  upstream_uris = ""
}

module "inventory_v2" {
  source = "../modules/fake-service"

  region        = var.region
  name          = "inventory-v2"
  port          = local.service_ports.inventory
  upstream_uris = ""
}

resource "kubernetes_manifest" "service_intentions_inventory" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ServiceIntentions"
    "metadata" = {
      "name"      = "inventory"
      "namespace" = var.namespace
    }
    "spec" = {
      "destination" = {
        "name" = "inventory"
      }
      "sources" = [
        {
          "action" = "allow"
          "name"   = "store"
        }
      ]
    }
  }
}