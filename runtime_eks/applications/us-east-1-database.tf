module "database_us_east_1" {
  source = "./modules/fake-service"

  region        = "us-east-1"
  name          = "database"
  port          = local.service_ports.database
  upstream_uris = ""

  providers = {
    kubernetes = kubernetes.us_east_1
  }
}

resource "kubernetes_manifest" "service_intentions_database_us_east_1" {
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

  provider = kubernetes.us_east_1
}