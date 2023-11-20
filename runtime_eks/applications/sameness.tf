resource "kubernetes_manifest" "sameness_group_us_east_1_application" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "SamenessGroup"
    "metadata" = {
      "name"      = "application"
      "namespace" = var.namespace
    }
    "spec" = {
      "includeLocal"       = true
      "defaultForFailover" = true
      "members" = [
        {
          "peer" = local.peers.us_west_2
        },
      ]
    }
  }

  provider = kubernetes.us_east_1
}

resource "kubernetes_manifest" "sameness_group_us_west_2_application" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "SamenessGroup"
    "metadata" = {
      "name"      = "application"
      "namespace" = var.namespace
    }
    "spec" = {
      "includeLocal"       = true
      "defaultForFailover" = true
      "members" = [
        {
          "peer" = local.peers.us_east_1
        },
      ]
    }
  }

  provider = kubernetes.us_west_2
}
