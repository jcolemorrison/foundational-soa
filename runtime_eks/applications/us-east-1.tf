module "fake_service_us_east_1" {
  source = "./region"

  region                    = "us-east-1"
  namespace                 = var.namespace
  test_failover_application = true

  providers = {
    kubernetes = kubernetes.us_east_1
  }
}

resource "kubernetes_manifest" "service_resolver_web_to_application" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ServiceResolver"
    "metadata" = {
      "name"      = "application"
      "namespace" = var.namespace
    }
    "spec" = {
      "connectTimeout" = "1s"
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