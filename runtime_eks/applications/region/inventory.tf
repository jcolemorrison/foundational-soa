module "inventory" {
  source = "../modules/fake-service"

  region                 = var.region
  name                   = "inventory"
  port                   = local.service_ports.inventory
  upstream_uris          = ""
  create_service_default = true
}

module "inventory_v2" {
  source = "../modules/fake-service"

  region                 = var.region
  name                   = "inventory-v2"
  port                   = local.service_ports.inventory
  upstream_uris          = ""
  create_service_default = true
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

resource "consul_config_entry" "service_splitter_inventory" {
  kind = "service-splitter"
  name = "inventory"

  config_json = jsonencode({
    Splits = [
      {
        Weight = var.enable_inventory_v2 ? 50 : 100
      },
      {
        Weight  = var.enable_inventory_v2 ? 50 : 0
        Service = "inventory-v2"
      },
    ]
  })
}
