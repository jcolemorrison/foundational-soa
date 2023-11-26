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

resource "consul_config_entry" "exported_services_payments_ec2" {
  name      = "ec2"
  kind      = "exported-services"
  partition = "ec2"

  config_json = jsonencode({
    Services = [{
      Name      = "payments"
      Namespace = "default"
      Consumers = [
        {
          Partition = "default"
        },
        {
          SamenessGroup = var.sameness_group
        }
      ]
    }]
  })
}