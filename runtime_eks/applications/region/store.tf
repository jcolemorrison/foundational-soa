# resource "kubernetes_manifest" "reference_grant" {
#   manifest = {
#     "apiVersion" = "gateway.networking.k8s.io/v1beta1"
#     "kind"       = "ReferenceGrant"
#     "metadata" = {
#       "name"      = "consul-reference-grant"
#       "namespace" = var.namespace
#     }
#     "spec" = {
#       "from" = [
#         {
#           "group"     = "gateway.networking.k8s.io"
#           "kind"      = "HTTPRoute"
#           "namespace" = "consul"
#         },
#       ]
#       "to" = [
#         {
#           "group" = ""
#           "kind"  = "Service"
#         },
#       ]
#     }
#   }
# }

# resource "kubernetes_manifest" "route_retry_filter" {
#   manifest = {
#     "apiVersion" = "consul.hashicorp.com/v1alpha1"
#     "kind"       = "RouteRetryFilter"
#     "metadata" = {
#       "name"      = "route-root"
#       "namespace" = var.namespace
#     }
#     "spec" = {
#       "numRetries" = 10
#       "retryOn" = [
#         "5xx",
#         "connect-failure"
#       ]
#       "retryOnConnectFailure" = true
#     }
#   }
# }

# resource "kubernetes_manifest" "http_route" {
#   manifest = {
#     "apiVersion" = "gateway.networking.k8s.io/v1beta1"
#     "kind"       = "HTTPRoute"
#     "metadata" = {
#       "name"      = "route-root"
#       "namespace" = var.namespace
#     }
#     "spec" = {
#       "parentRefs" = [
#         {
#           "name"      = "api-gateway"
#           "namespace" = "consul"
#         },
#       ]
#       "rules" = [
#         {
#           "backendRefs" = [
#             {
#               "kind"      = "Service"
#               "name"      = "store"
#               "namespace" = var.namespace
#               "port"      = local.service_ports.store
#             },
#           ]
#           "matches" = [
#             {
#               "path" = {
#                 "type"  = "PathPrefix"
#                 "value" = "/"
#               }
#             },
#           ]
#           "filters" = [
#             {
#               "extensionRef" = {
#                 "group" = "consul.hashicorp.com"
#                 "kind"  = "RouteRetryFilter"
#                 "name"  = "route-root"
#               }
#               "type" = "ExtensionRef"
#             },
#           ]
#         },
#       ]
#     }
#   }
# }

locals {
  customers_url = "http://customers.virtual.consul"
  payments_url  = "http://payments.virtual.consul"
}

module "store" {
  source = "../modules/fake-service"

  region        = var.region
  name          = "store"
  port          = local.service_ports.store
  upstream_uris = var.enable_payments_service ? "${local.customers_url},${local.payments_url}" : local.customers_url
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
          "action"    = "allow"
          "name"      = "ecs-api"
          "partition" = "ecs"
        }
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
        }
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
        "service"       = "payments"
        "partition"     = "ec2"
        "samenessGroup" = "payments"
      }
    }
  }
}
