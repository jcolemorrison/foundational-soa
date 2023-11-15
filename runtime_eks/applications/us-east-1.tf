locals {
  web_port = 9090
}

resource "kubernetes_manifest" "referencegrant_consul_reference_grant" {
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

resource "kubernetes_manifest" "httproute_route_root" {
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
              "port"      = local.web_port
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

resource "kubernetes_manifest" "service_web" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Service"
    "metadata" = {
      "name"      = "web"
      "namespace" = var.namespace
    }
    "spec" = {
      "ports" = [
        {
          "name"       = "http"
          "port"       = local.web_port
          "protocol"   = "TCP"
          "targetPort" = local.web_port
        },
      ]
      "selector" = {
        "app" = "web"
      }
    }
  }

  provider = kubernetes.us_east_1
}

resource "kubernetes_manifest" "serviceaccount_web" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "ServiceAccount"
    "metadata" = {
      "name"      = "web"
      "namespace" = var.namespace
    }
  }

  provider = kubernetes.us_east_1
}

resource "kubernetes_manifest" "deployment_web" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "Deployment"
    "metadata" = {
      "labels" = {
        "app" = "web"
      }
      "name"      = "web"
      "namespace" = var.namespace
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "web"
        }
      }
      "template" = {
        "metadata" = {
          "annotations" = {
            "consul.hashicorp.com/connect-inject" = "true"
          }
          "labels" = {
            "app" = "web"
          }
        }
        "spec" = {
          "containers" = [
            {
              "env" = [
                {
                  "name"  = "LISTEN_ADDR"
                  "value" = "0.0.0.0:${local.web_port}"
                },
                {
                  "name"  = "UPSTREAM_URIS"
                  "value" = "http://application.virtual.prod-us-west-2-default.consul"
                },
                {
                  "name"  = "NAME"
                  "value" = "web-us-east-1"
                },
                {
                  "name"  = "MESSAGE"
                  "value" = "Response from web in us-east-1"
                },
              ]
              "image" = var.container_image
              "name"  = "web"
              "ports" = [
                {
                  "containerPort" = local.web_port
                },
              ]
            },
          ]
          "serviceAccountName" = "web"
        }
      }
    }
  }

  provider = kubernetes.us_east_1
}

resource "kubernetes_manifest" "servicedefaults_web" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ServiceDefaults"
    "metadata" = {
      "name"      = "web"
      "namespace" = var.namespace
    }
    "spec" = {
      "protocol" = "http"
    }
  }

  provider = kubernetes.us_east_1
}

resource "kubernetes_manifest" "serviceintentions_application" {
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
      ]
    }
  }

  provider = kubernetes.us_east_1
}

resource "kubernetes_manifest" "serviceintentions_web" {
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