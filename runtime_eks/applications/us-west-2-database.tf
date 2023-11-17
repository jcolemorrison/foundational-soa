module "database_us_west_2" {
  source = "./modules/fake-service"

  region        = "us-west-2"
  name          = "database"
  port          = local.service_ports.database
  upstream_uris = ""

  providers = {
    kubernetes = kubernetes.us_west_2
  }
}

resource "kubernetes_manifest" "service_intentions_database_us_west_2" {
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