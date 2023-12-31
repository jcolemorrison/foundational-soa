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
      "annotations" = var.enable_load_balancer ? {
        "service.beta.kubernetes.io/aws-load-balancer-ssl-cert" = "${var.certificate_arn}"
        "service.beta.kubernetes.io/aws-load-balancer-scheme"   = "internet-facing"
        "service.beta.kubernetes.io/aws-load-balancer-subnets"  = join(",", var.public_subnet_ids)
      } : {}
    }
    "spec" = {
      "type" = var.enable_load_balancer ? "LoadBalancer" : "ClusterIP"
      "ports" = [
        {
          "name"       = "http"
          "port"       = var.enable_load_balancer ? 443 : var.port
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
    },
    {
      "name"  = "ERROR_RATE"
      "value" = var.error_rate
    },
    {
      "name"  = "ERROR_TYPE"
      "value" = "delay"
    },
    {
      "name"  = "ERROR_DELAY"
      "value" = "100s"
    },
    {
      "name"  = "ERROR_CODE"
      "value" = var.error_code
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
          "annotations" = var.enable_load_balancer ? {
            "consul.hashicorp.com/connect-inject"                          = "true"
            "consul.hashicorp.com/transparent-proxy-exclude-inbound-ports" = "9090"
            } : {
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
  count = var.create_service_default ? 1 : 0
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ServiceDefaults"
    "metadata" = {
      "name"      = var.name
      "namespace" = var.namespace
    }
    "spec" = {
      "protocol" = var.protocol
    }
  }
}
