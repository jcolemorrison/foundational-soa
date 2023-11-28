## Deploy Consul mesh gateway
resource "random_integer" "mesh_gateway" {
  min = 0
  max = length(module.network.vpc_private_subnet_ids) - 1
}

locals {
  consul_tag = {
    "Consul" = "Mesh Gateway"
  }
}

module "mesh_gateway" {
  source = "../modules/consul/mesh_gateway"

  vpc_id            = module.network.vpc_id
  vpc_cidr_block    = module.network.vpc_cidr_block
  subnet_id         = module.network.vpc_private_subnet_ids[random_integer.mesh_gateway.result]
  public_subnet_ids = module.network.vpc_public_subnet_ids

  security_group_ids = [aws_security_group.instances.id]

  hcp_consul_cluster_id    = var.hcp_consul_cluster_id
  hcp_consul_cluster_token = var.hcp_consul_cluster_token

  key_pair_name = aws_key_pair.boundary.key_name

  tags = merge(local.boundary_tag, local.consul_tag)
}

locals {
  peers = [for peer in var.peers_for_failover : {
    "Peer" = peer
  }]
  consul_partitions = ["ec2", "default", "ecs"]
  partitions = [for partition in local.consul_partitions : {
    "Partition" = partition
  }]
}

# resource "consul_config_entry" "sameness_group" {
#   kind      = "sameness-group"
#   name      = var.sameness_group
#   partition = var.runtime

#   config_json = jsonencode({
#     DefaultForFailover = true
#     IncludeLocal       = false
#     Members            = concat(local.partitions, local.peers)
#   })
# }

# resource "consul_config_entry" "exported_services_payments_ec2" {
#   count     = var.deploy_services ? 1 : 0
#   name      = var.runtime
#   kind      = "exported-services"
#   partition = var.runtime

#   config_json = jsonencode({
#     Services = [{
#       Name      = "payments"
#       Namespace = "default"
#       Consumers = [
#         {
#           SamenessGroup = var.sameness_group
#         }
#       ] }, {
#       Name      = "mesh-gateway"
#       Namespace = "default"
#       Consumers = local.partitions
#     }]
#   })
# }