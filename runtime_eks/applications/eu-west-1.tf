module "fake_service_eu_west_1" {
  source = "./region"

  region    = "eu-west-1"
  namespace = var.namespace

  peers_for_failover = [local.peers.us_west_2, local.peers.us_east_1]

  providers = {
    kubernetes = kubernetes.eu_west_1
  }
}

resource "kubernetes_manifest" "exported_services_default_eu_west_1" {
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
              "samenessGroup" = module.fake_service_eu_west_1.sameness_group
            },
          ]
          "name" = "database"
        },
      ]
    }
  }


  provider = kubernetes.eu_west_1
}
