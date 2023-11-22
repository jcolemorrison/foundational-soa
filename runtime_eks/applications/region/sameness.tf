locals {
  peers = [for peer in var.peers_for_failover : {
    "peer" = peer
  }]
}

resource "kubernetes_manifest" "sameness_group" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "SamenessGroup"
    "metadata" = {
      "name"      = var.sameness_group_name
      "namespace" = var.namespace
    }
    "spec" = {
      "includeLocal"       = true
      "defaultForFailover" = false
      "members"            = local.peers
    }
  }
}
