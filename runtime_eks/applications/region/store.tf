locals {
  customers_url = "http://customers.virtual.consul"
  payments_url  = "http://payments.virtual.consul"
  inventory_url = "http://inventory.virtual.consul"

  store_upstream_uri_base = "${local.customers_url},${local.inventory_url}"
}

module "store" {
  source = "../modules/fake-service"

  region               = var.region
  name                 = "store"
  port                 = local.service_ports.store
  upstream_uris        = var.enable_payments_service ? "${local.store_upstream_uri_base},${local.payments_url}" : local.store_upstream_uri_base
  enable_load_balancer = true
  certificate_arn      = var.certificate_arn
}

resource "kubernetes_manifest" "service_intentions_store" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ServiceIntentions"
    "metadata" = {
      "name"      = "store"
      "namespace" = var.namespace
    }
    "spec" = {
      "destination" = {
        "name" = "store"
      }
      "sources" = [
        {
          "action" = "allow"
          "name"   = "api-gateway"
        },
        {
          "action"        = "allow"
          "name"          = "ecs-api"
          "samenessGroup" = var.sameness_group_name
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "service_intentions_payments" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ServiceIntentions"
    "metadata" = {
      "name"      = "payments"
      "namespace" = var.namespace
    }
    "spec" = {
      "destination" = {
        "name" = "payments"
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

resource "kubernetes_manifest" "service_resolver_store_to_payments" {
  count = var.enable_payments_service ? 1 : 0
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ServiceResolver"
    "metadata" = {
      "name"      = "payments"
      "namespace" = var.namespace
    }
    "spec" = {
      "redirect" = {
        "samenessGroup" = var.sameness_group_name
      }
    }
  }
}
