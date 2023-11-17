module "application_us_east_1" {
  source = "./modules/fake-service"

  region        = "us-east-1"
  name          = "application"
  port          = local.service_ports.application
  upstream_uris = "http://database.virtual.consul"

  providers = {
    kubernetes = kubernetes.us_east_1
  }
}

resource "kubernetes_manifest" "service_intentions_application" {
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