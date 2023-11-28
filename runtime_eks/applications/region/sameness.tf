locals {
  peers = [for peer in var.peers_for_failover : {
    "peer" = peer
  }]
  consul_partitions = ["default", "ec2", "ecs"]
  partitions = [for partition in local.consul_partitions : {
    "partition" = partition
  }]
}

# resource "kubernetes_manifest" "sameness_group" {
#   manifest = {
#     "apiVersion" = "consul.hashicorp.com/v1alpha1"
#     "kind"       = "SamenessGroup"
#     "metadata" = {
#       "name"      = var.sameness_group_name
#       "namespace" = var.namespace
#     }
#     "spec" = {
#       "includeLocal"       = false
#       "defaultForFailover" = true
#       "members"            = concat(local.partitions, local.peers)
#     }
#   }
# }