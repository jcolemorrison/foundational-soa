locals {
  database_port = 9090
}

resource "kubernetes_manifest" "servicedefaults_database" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ServiceDefaults"
    "metadata" = {
      "name"      = "database"
      "namespace" = var.namespace
    }
    "spec" = {
      "protocol" = "http"
    }
  }

  provider = kubernetes.eu_west_1
}

resource "kubernetes_manifest" "service_database" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Service"
    "metadata" = {
      "name"      = "database"
      "namespace" = var.namespace
    }
    "spec" = {
      "ports" = [
        {
          "name"       = "http"
          "port"       = local.database_port
          "protocol"   = "TCP"
          "targetPort" = local.database_port
        },
      ]
      "selector" = {
        "app" = "database"
      }
    }
  }

  provider = kubernetes.eu_west_1
}

resource "kubernetes_manifest" "serviceaccount_database" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "ServiceAccount"
    "metadata" = {
      "name"      = "database"
      "namespace" = var.namespace
    }
  }


  provider = kubernetes.eu_west_1
}

resource "kubernetes_manifest" "deployment_database" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "Deployment"
    "metadata" = {
      "labels" = {
        "app" = "database"
      }
      "name"      = "database"
      "namespace" = var.namespace
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "database"
        }
      }
      "template" = {
        "metadata" = {
          "annotations" = {
            "consul.hashicorp.com/connect-inject" = "true"
          }
          "labels" = {
            "app" = "database"
          }
        }
        "spec" = {
          "containers" = [
            {
              "env" = [
                {
                  "name"  = "LISTEN_ADDR"
                  "value" = "0.0.0.0:${local.database_port}"
                },
                {
                  "name"  = "NAME"
                  "value" = "database-eu-west-1"
                },
                {
                  "name"  = "MESSAGE"
                  "value" = "Response from database in eu-west-1"
                },
              ]
              "image" = var.container_image
              "name"  = "database"
              "ports" = [
                {
                  "containerPort" = local.database_port
                },
              ]
            },
          ]
          "serviceAccountName" = "database"
        }
      }
    }
  }

  provider = kubernetes.eu_west_1
}

resource "kubernetes_manifest" "exportedservices_default_eu_west_1" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ExportedServices"
    "metadata" = {
      "name"      = "default"
      "namespace" = var.namespace
    }
    "spec" = {
      "services" = [
        {
          "consumers" = [
            {
              "peer" = "prod-us-west-2-default"
            },
          ]
          "name" = "database"
        },
      ]
    }
  }


  provider = kubernetes.eu_west_1
}

resource "kubernetes_manifest" "serviceintentions_database_peered" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ServiceIntentions"
    "metadata" = {
      "name"      = "database"
      "namespace" = var.namespace
    }
    "spec" = {
      "destination" = {
        "name" = "database"
      }
      "sources" = [
        {
          "action" = "allow"
          "name"   = "application"
          "peer"   = "prod-us-west-2-default"
        },
      ]
    }
  }

  provider = kubernetes.eu_west_1
}
