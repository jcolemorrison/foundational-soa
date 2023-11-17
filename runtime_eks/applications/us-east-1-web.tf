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

  provider = kubernetes.us_east_1
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
              "name"      = "web"
              "namespace" = var.namespace
              "port"      = local.service_ports.web
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
        },
      ]
    }
  }

  provider = kubernetes.us_east_1
}

module "web_us_east_1" {
  source = "./modules/fake-service"

  region        = "us-east-1"
  name          = "web"
  port          = local.service_ports.web
  upstream_uris = "http://application.virtual.consul"

  providers = {
    kubernetes = kubernetes.us_east_1
  }
}

resource "kubernetes_manifest" "service_intentions_web" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ServiceIntentions"
    "metadata" = {
      "name"      = "web"
      "namespace" = var.namespace
    }
    "spec" = {
      "destination" = {
        "name" = "web"
      }
      "sources" = [
        {
          "action" = "allow"
          "name"   = "api-gateway"
        },
      ]
    }
  }

  provider = kubernetes.us_east_1
}

resource "kubernetes_manifest" "service_resolver_application" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ServiceResolver"
    "metadata" = {
      "name"      = "application"
      "namespace" = var.namespace
    }
    "spec" = {
      "connectTimeout" = "5s"
      "failover" = {
        "*" = {
          "targets" = [
            {
              "peer" = local.peers.us_west_2
            },
          ]
        }
      }
    }
  }

  provider = kubernetes.us_east_1
}
