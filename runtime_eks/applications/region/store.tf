resource "kubernetes_manifest" "reference_grant" {
  manifest = {
    "apiVersion" = "gateway.networking.k8s.io/v1beta1"
    "kind"       = "ReferenceGrant"
    "metadata" = {
      "name"      = "consul-reference-grant"
      "namespace" = var.namespace
    }
    "spec" = {
      "from" = [
        {
          "group"     = "gateway.networking.k8s.io"
          "kind"      = "HTTPRoute"
          "namespace" = "consul"
        },
      ]
      "to" = [
        {
          "group" = ""
          "kind"  = "Service"
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "route_retry_filter" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "RouteRetryFilter"
    "metadata" = {
      "name"      = "route-root"
      "namespace" = var.namespace
    }
    "spec" = {
      "numRetries" = 10
      "retryOn" = [
        "5xx",
        "connect-failure"
      ]
      "retryOnConnectFailure" = true
    }
  }
}

resource "kubernetes_manifest" "http_route" {
  manifest = {
    "apiVersion" = "gateway.networking.k8s.io/v1beta1"
    "kind"       = "HTTPRoute"
    "metadata" = {
      "name"      = "route-root"
      "namespace" = var.namespace
    }
    "spec" = {
      "parentRefs" = [
        {
          "name"      = "api-gateway"
          "namespace" = "consul"
        },
      ]
      "rules" = [
        {
          "backendRefs" = [
            {
              "kind"      = "Service"
              "name"      = "store"
              "namespace" = var.namespace
              "port"      = local.service_ports.store
            },
          ]
          "matches" = [
            {
              "path" = {
                "type"  = "PathPrefix"
                "value" = "/"
              }
            },
          ]
          "filters" = [
            {
              "extensionRef" = {
                "group" = "consul.hashicorp.com"
                "kind"  = "RouteRetryFilter"
                "name"  = "route-root"
              }
              "type" = "ExtensionRef"
            },
          ]
        },
      ]
    }
  }
}

module "store" {
  source = "../modules/fake-service"

  region        = var.region
  name          = "store"
  port          = local.service_ports.store
  upstream_uris = "http://customers.virtual.consul"
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
        }
      ]
    }
  }
}
