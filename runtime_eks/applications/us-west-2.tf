locals {
  application_port = 9090
}

resource "kubernetes_manifest" "servicedefaults_application" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ServiceDefaults"
    "metadata" = {
      "name"      = "application"
      "namespace" = var.namespace
    }
    "spec" = {
      "protocol" = "http"
    }
  }

  provider = kubernetes.us_west_2
}

resource "kubernetes_manifest" "service_application" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Service"
    "metadata" = {
      "name"      = "application"
      "namespace" = var.namespace
    }
    "spec" = {
      "ports" = [
        {
          "name"       = "http"
          "port"       = local.application_port
          "protocol"   = "TCP"
          "targetPort" = local.application_port
        },
      ]
      "selector" = {
        "app" = "application"
      }
    }
  }

  provider = kubernetes.us_west_2
}

resource "kubernetes_manifest" "serviceaccount_application" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "ServiceAccount"
    "metadata" = {
      "name"      = "application"
      "namespace" = var.namespace
    }
  }

  provider = kubernetes.us_west_2
}

resource "kubernetes_manifest" "deployment_application" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "Deployment"
    "metadata" = {
      "labels" = {
        "app" = "application"
      }
      "name"      = "application"
      "namespace" = var.namespace
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "application"
        }
      }
      "template" = {
        "metadata" = {
          "annotations" = {
            "consul.hashicorp.com/connect-inject" = "true"
          }
          "labels" = {
            "app" = "application"
          }
        }
        "spec" = {
          "containers" = [
            {
              "env" = [
                {
                  "name"  = "LISTEN_ADDR"
                  "value" = "0.0.0.0:${local.application_port}"
                },
                {
                  "name"  = "UPSTREAM_URIS"
                  "value" = "http://database.virtual.prod-eu-west-1-default.consul"
                },
                {
                  "name"  = "NAME"
                  "value" = "application-us-west-2"
                },
                {
                  "name"  = "MESSAGE"
                  "value" = "Response from application in us-west-2"
                },
              ]
              "image" = var.container_image
              "name"  = "application"
              "ports" = [
                {
                  "containerPort" = local.application_port
                },
              ]
            },
          ]
          "serviceAccountName" = "application"
        }
      }
    }
  }

  provider = kubernetes.us_west_2
}

resource "kubernetes_manifest" "serviceintentions_database" {
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
        },
      ]
    }
  }

  provider = kubernetes.us_west_2
}
