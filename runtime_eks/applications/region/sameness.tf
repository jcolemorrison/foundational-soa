locals {
  peers = [for peer in var.peers_for_failover : {
    "peer" = peer
  }]
  consul_partitions = ["default", "ec2", "ecs"]
  partitions = [for partition in local.consul_partitions : {
    "partition" = partition
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
      "includeLocal"       = false
      "defaultForFailover" = true
      "members"            = concat(local.peers, local.partitions)
    }
  }
}

locals {
  payments_sameness_group = "payments"
  store_sameness_group    = "store"
}

resource "kubernetes_manifest" "sameness_group_payments" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "SamenessGroup"
    "metadata" = {
      "name"      = local.payments_sameness_group
      "namespace" = var.namespace
    }
    "spec" = {
      "includeLocal"       = false
      "defaultForFailover" = true
      "members"            = concat(local.partitions)
    }
  }
}

resource "kubernetes_manifest" "sameness_group_store" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "SamenessGroup"
    "metadata" = {
      "name"      = local.store_sameness_group
      "namespace" = var.namespace
    }
    "spec" = {
      "includeLocal"       = false
      "defaultForFailover" = true
      "members"            = concat(local.partitions)
    }
  }
}