module "static" {
  source = "../../../../modules/fake_service"

  service = var.name
  runtime = var.runtime
  region  = var.region
}

locals {
  database_credentials = "database-creds"
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
              "env" = [
                {
                  "name"  = "LISTEN_ADDR"
                  "value" = "0.0.0.0:${var.port}"
                },
                {
                  "name"  = "NAME"
                  "value" = module.static.name
                },
                {
                  "name"  = "DATABASE_HOST"
                  "value" = var.database_host
                },
                {
                  "name" = "DATABASE_USER"
                  "valueFrom" = {
                    "secretKeyRef" = {
                      "key"  = "username"
                      "name" = local.database_credentials
                    }
                  }
                },
                {
                  "name" = "DATABASE_PASSWORD"
                  "valueFrom" = {
                    "secretKeyRef" = {
                      "key"  = "password"
                      "name" = local.database_credentials
                    }
                  }
                },
              ]
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

resource "kubernetes_manifest" "vault_auth" {
  manifest = {
    "apiVersion" = "secrets.hashicorp.com/v1beta1"
    "kind"       = "VaultAuth"
    "metadata" = {
      "name"      = var.name
      "namespace" = var.namespace
    }
    "spec" = {
      "kubernetes" = {
        "audiences" = [
          "vault",
        ]
        "role"           = var.name
        "serviceAccount" = var.name
      }
      "method"    = "kubernetes"
      "mount"     = "kubernetes"
      "namespace" = var.vault_namespace
    }
  }
}

resource "kubernetes_manifest" "vault_dynamic_secret" {
  manifest = {
    "apiVersion" = "secrets.hashicorp.com/v1beta1"
    "kind"       = "VaultDynamicSecret"
    "metadata" = {
      "name"      = var.name
      "namespace" = var.namespace
    }
    "spec" = {
      "destination" = {
        "create" = true
        "name"   = local.database_credentials
        "type"   = "Opaque"
      }
      "mount"        = var.vault_database_path
      "path"         = "creds"
      "refreshAfter" = "1m"
      "rolloutRestartTargets" = [
        {
          "kind" = "Deployment"
          "name" = var.name
        }
      ]
      "vaultAuthRef" = "payments-processor"
    }
  }
}