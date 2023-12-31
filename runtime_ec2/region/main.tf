locals {
  security_group_rules = {
    allow_in_security_group = {
      description = "Allow instances in security group to communicate with each other"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    },
    boundary_worker_22 = {
      description                   = "Allow Boundary workers to SSH"
      protocol                      = "tcp"
      from_port                     = 22
      to_port                       = 22
      type                          = "ingress"
      source_cluster_security_group = module.boundary_worker.0.security_group_id
    },
    consul_tcp = {
      description = "Allow Consul gossip"
      protocol    = "tcp"
      from_port   = 8300
      to_port     = 8300
      type        = "ingress"
      cidr_blocks = [var.hcp_hvn_cidr_block]
    },
    consul_udp_8301 = {
      description = "Allow Consul to communicate with instance over UDP"
      protocol    = "udp"
      from_port   = 8301
      to_port     = 8301
      type        = "ingress"
      cidr_blocks = [var.hcp_hvn_cidr_block]
    },
    consul_tcp_8301 = {
      description = "Allow Consul to communicate with instance over TCP"
      protocol    = "tcp"
      from_port   = 8301
      to_port     = 8301
      type        = "ingress"
      cidr_blocks = [var.hcp_hvn_cidr_block]
    },
    consul_tcp_8502 = {
      description = "Allow Consul to communicate over grpc"
      protocol    = "tcp"
      from_port   = 8502
      to_port     = 8502
      type        = "ingress"
      cidr_blocks = [var.hcp_hvn_cidr_block]
    },
    consul_mesh_gateway_8443 = {
      description = "Allow Consul to communicate with mesh gateways"
      protocol    = "tcp"
      from_port   = 8443
      to_port     = 8443
      type        = "ingress"
      cidr_blocks = concat([var.hcp_hvn_cidr_block], var.accessible_cidr_blocks)
    },
    consul_mesh_gateway_envoy_20000_22000 = {
      description = "Allow Consul to communicate with mesh gateways"
      protocol    = "tcp"
      from_port   = 20000
      to_port     = 22000
      type        = "ingress"
      cidr_blocks = concat([var.hcp_hvn_cidr_block], var.accessible_cidr_blocks)
    },
    consul_mesh_gateway_wan = {
      description = "Allow Consul to communicate with mesh gatewaysP"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = concat([var.hcp_hvn_cidr_block], var.accessible_cidr_blocks)
    },
    egress = {
      description = "Allow all egress"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  boundary_tag = {
    Boundary = "true"
  }
  application_tag = {
    Application = "true"
  }
}

resource "aws_security_group" "instances" {
  name_prefix = "runtime-${var.runtime}-instances-"
  description = "Security group for ${var.runtime} instances"
  vpc_id      = module.network.vpc_id

  tags = {
    Name = "runtime-${var.runtime}-instances"
  }
}

resource "aws_security_group_rule" "instances" {
  for_each = local.security_group_rules

  # Required
  security_group_id = aws_security_group.instances.id
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  type              = each.value.type

  # Optional
  description              = lookup(each.value, "description", null)
  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(each.value, "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(each.value, "prefix_list_ids", [])
  self                     = lookup(each.value, "self", null)
  source_security_group_id = lookup(each.value, "source_cluster_security_group", null)
}

## Deploy example service

module "payments_static" {
  count   = var.deploy_services ? 1 : 0
  source  = "../../modules/fake_service"
  region  = var.region
  service = "payments"
  runtime = var.runtime
}

resource "random_integer" "payments_subnet" {
  count = var.deploy_services ? 1 : 0
  min   = 0
  max   = length(module.network.vpc_private_subnet_ids) - 1
}

module "payments" {
  count                = var.deploy_services ? 1 : 0
  source               = "../modules/ec2"
  name                 = "payments"
  fake_service_name    = module.payments_static.0.name
  fake_service_message = module.payments_static.0.message

  vpc_id         = module.network.vpc_id
  vpc_cidr_block = module.network.vpc_cidr_block
  subnet_id      = module.network.vpc_private_subnet_ids[random_integer.payments_subnet.0.result]

  security_group_ids = [aws_security_group.instances.id]

  hcp_consul_cluster_id    = var.hcp_consul_cluster_id
  hcp_consul_cluster_token = var.hcp_consul_cluster_token

  key_pair_name = aws_key_pair.boundary.key_name

  tags = merge(local.boundary_tag, local.application_tag)
}

resource "consul_config_entry" "service_defaults_payments" {
  count     = var.deploy_services ? 1 : 0
  name      = "payments"
  kind      = "service-defaults"
  partition = "ec2"

  config_json = jsonencode({
    Protocol = "http"
  })
}

module "reports_static" {
  count   = var.deploy_services ? 1 : 0
  source  = "../../modules/fake_service"
  region  = var.region
  service = "reports"
  runtime = var.runtime
}

module "reports" {
  count                 = var.deploy_services ? 1 : 0
  source                = "../modules/ec2"
  name                  = "reports"
  fake_service_name     = module.reports_static.0.name
  fake_service_message  = module.reports_static.0.message
  upstream_service_name = "payments"

  vpc_id         = module.network.vpc_id
  vpc_cidr_block = module.network.vpc_cidr_block
  subnet_id      = module.network.vpc_private_subnet_ids[random_integer.payments_subnet.0.result]

  security_group_ids = [aws_security_group.instances.id]

  hcp_consul_cluster_id    = var.hcp_consul_cluster_id
  hcp_consul_cluster_token = var.hcp_consul_cluster_token

  key_pair_name = aws_key_pair.boundary.key_name

  tags = merge(local.boundary_tag, local.application_tag)
}

resource "consul_config_entry" "service_defaults_reports" {
  count     = var.deploy_services ? 1 : 0
  name      = "reports"
  kind      = "service-defaults"
  partition = "ec2"

  config_json = jsonencode({
    Protocol = "http"
  })
}

resource "consul_config_entry" "payments_intentions" {
  name      = "payments"
  kind      = "service-intentions"
  partition = var.runtime

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = "reports"
        Precedence = 9
        Type       = "consul"
        Namespace  = "default"
        Partition  = var.runtime
      },
      {
        Action     = "allow"
        Name       = "store"
        Precedence = 9
        Type       = "consul"
        Partition  = "default"
      },
      {
        Action     = "allow"
        Name       = "ecs-api"
        Precedence = 9
        Type       = "consul"
        Partition  = "ecs"
      }
    ]
  })
}
