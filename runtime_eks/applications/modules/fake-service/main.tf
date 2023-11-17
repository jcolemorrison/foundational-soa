module "static" {
  source = "../../../../modules/fake_service"

  service = var.name
  runtime = var.runtime
  region  = var.region
}

resource "kubernetes_manifest" "service" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Service"
    "metadata" = {
      "name"      = var.name
      "namespace" = var.namespace
    }
    "spec" = {
      "ports" = [
        {
          "name"       = "http"
          "port"       = var.port
          "protocol"   = "TCP"
          "targetPort" = var.port
        },
      ]
      "selector" = {
        "app" = var.name
      }
    }
  }
}

resource "kubernetes_manifest" "service_account" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "ServiceAccount"
    "metadata" = {
      "name"      = var.name
      "namespace" = var.namespace
    }
  }
}

locals {
  base_env_vars = [
    {
      "name"  = "LISTEN_ADDR"
      "value" = "0.0.0.0:${var.port}"
    },
    {
      "name"  = "NAME"
      "value" = module.static.name
    },
    {
      "name"  = "MESSAGE"
      "value" = module.static.message
    }
  ]
  env_vars = var.upstream_uris != "" ? concat(local.base_env_vars, [{
    "name"  = "UPSTREAM_URIS"
    "value" = var.upstream_uris
  }]) : local.base_env_vars
}

resource "kubernetes_manifest" "deployment" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "Deployment"
    "metadata" = {
      "labels" = {
        "app" = var.name
      }
      "name"      = var.name
      "namespace" = var.namespace
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = var.name
        }
      }
      "template" = {
        "metadata" = {
          "annotations" = {
            "consul.hashicorp.com/connect-inject" = "true"
          }
          "labels" = {
            "app" = var.name
          }
        }
        "spec" = {
          "containers" = [
            {
              "env"   = local.env_vars
              "image" = module.static.container_image
              "name"  = var.name
              "ports" = [
                {
                  "containerPort" = var.port
                },
              ]
            },
          ]
          "serviceAccountName" = var.name
        }
      }
    }
  }
}

resource "kubernetes_manifest" "service_defaults" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ServiceDefaults"
    "metadata" = {
      "name"      = var.name
      "namespace" = var.namespace
    }
    "spec" = {
      "protocol" = "http"
    }
  }
}
