## A Generalized group for all consul clients

resource "aws_security_group" "consul_client" {
  name_prefix = "consul-client-"
  description = "General security group for consul clients."
  vpc_id      = module.network.vpc_id
}

// Required for gossip traffic between each client
resource "aws_security_group_rule" "consul_client_allow_inbound_self_8301" {
  security_group_id = aws_security_group.consul_client.id
  type              = "ingress"
  protocol          = "tcp"
  self              = true
  from_port         = 8301
  to_port           = 8301
  description       = "Allow LAN Serf traffic from resources with this security group."
}

// Required for gossip traffic between each client
resource "aws_security_group_rule" "consul_client_allow_inbound_self_8301_udp" {
  security_group_id = aws_security_group.consul_client.id
  type              = "ingress"
  protocol          = "udp"
  self              = true
  from_port         = 8301
  to_port           = 8301
  description       = "Allow LAN Serf traffic from resources with this security group."
}


// Required for gossip traffic from clients to HCP HVN
resource "aws_security_group_rule" "consul_client_allow_inbound_HCP_8301_tcp" {
  security_group_id = aws_security_group.consul_client.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = [var.hcp_hvn_cidr_block]
  from_port         = 8301
  to_port           = 8301
  description       = "Allow TCP traffic from HCP with this security group."
}

resource "aws_security_group_rule" "consul_client_allow_inbound_HCP_8301_udp" {
  security_group_id = aws_security_group.consul_client.id
  type              = "ingress"
  protocol          = "udp"
  cidr_blocks       = [var.hcp_hvn_cidr_block]
  from_port         = 8301
  to_port           = 8301
  description       = "Allow UDP traffic from HCP with this security group."
}

// Allow Gossip from other Clients in different runtimes
resource "aws_security_group_rule" "consul_client_allow_inbound_runtimes_8301_tcp" {
  security_group_id = aws_security_group.consul_client.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = var.accessible_cidr_blocks
  from_port         = 8301
  to_port           = 8301
  description       = "Allow TCP traffic from resources in accessible cidr blocks."
}

resource "aws_security_group_rule" "consul_client_allow_inbound_runtimes_8301_udp" {
  security_group_id = aws_security_group.consul_client.id
  type              = "ingress"
  protocol          = "udp"
  cidr_blocks       = var.accessible_cidr_blocks
  from_port         = 8301
  to_port           = 8301
  description       = "Allow UDP traffic from resources in accessible cidr blocks."
}

// Required to allow the proxies to contact each other
resource "aws_security_group_rule" "consul_client_allow_inbound_self_20000" {
  security_group_id = aws_security_group.consul_client.id
  type              = "ingress"
  protocol          = "tcp"
  self              = true
  from_port         = 20000
  to_port           = 20000
  description       = "Allow Proxy traffic from resources with this security group."
}

resource "aws_security_group_rule" "consul_client_allow_inbound_runtimes_20000" {
  security_group_id = aws_security_group.consul_client.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = var.accessible_cidr_blocks
  from_port         = 0
  to_port           = 65535
  description       = "Allow Proxy traffic from resources in accessible cidr blocks."
}


resource "aws_security_group_rule" "consul_client_allow_outbound" {
  security_group_id = aws_security_group.consul_client.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow any outbound traffic."
}

## Container Instance Security Groups

resource "aws_security_group" "container_instance" {
  name_prefix = "${var.region}-ecs-instance-"
  description = "security group for ECS container instances"
  vpc_id      = module.network.vpc_id
}

resource "aws_security_group_rule" "container_instance_allow_alb_to_ephemeral" {
  type                     = "ingress"
  from_port                = 49153
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.container_instance.id
  source_security_group_id = aws_security_group.public_alb.id
}

resource "aws_security_group_rule" "container_instance_allow_ssh_boundary" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.container_instance.id
  source_security_group_id =  module.boundary_worker.0.security_group_id
}

resource "aws_security_group_rule" "container_instance_allow_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.container_instance.id
}

## Security Group for Public ALB

resource "aws_security_group" "public_alb" {
  name_prefix = "${var.region}-ecs-public-alb"
  description = "security group for public load balancer"
  vpc_id      = module.network.vpc_id
}

resource "aws_security_group_rule" "public_alb_allow_80" {
  security_group_id = aws_security_group.public_alb.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow HTTP traffic."
}

resource "aws_security_group_rule" "public_alb_allow_443" {
  security_group_id = aws_security_group.public_alb.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow HTTPS traffic."
}

resource "aws_security_group_rule" "public_alb_allow_outbound" {
  security_group_id = aws_security_group.public_alb.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow any outbound traffic."
}

## Security Group for ECS Client Service.

resource "aws_security_group" "ecs_api" {
  name_prefix = "ecs-client-service"
  description = "ECS Client service security group."
  vpc_id      = module.network.vpc_id
}

resource "aws_security_group_rule" "ecs_api_allow_9090" {
  security_group_id        = aws_security_group.ecs_api.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 9090
  to_port                  = 9090
  source_security_group_id = aws_security_group.public_alb.id
  description              = "Allow incoming traffic from the public ALB into the service container port."
}

resource "aws_security_group_rule" "ecs_api_allow_inbound_self" {
  security_group_id = aws_security_group.ecs_api.id
  type              = "ingress"
  protocol          = -1
  self              = true
  from_port         = 0
  to_port           = 0
  description       = "Allow traffic from resources with this security group."
}

resource "aws_security_group_rule" "ecs_api_allow_outbound" {
  security_group_id = aws_security_group.ecs_api.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow any outbound traffic."
}