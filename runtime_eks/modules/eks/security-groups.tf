locals {
  cluster_sg_name = "${var.name}-cluster"
  cluster_security_group_rules = {
    ingress_nodes_443 = {
      description                = "Node groups to cluster API"
      protocol                   = "tcp"
      from_port                  = 443
      to_port                    = 443
      type                       = "ingress"
      source_node_security_group = "${aws_security_group.node.id}"
    },
  }

  node_sg_name = "${var.name}-node-group"
  node_security_group_rules = {
    ingress_cluster_443 = {
      description                   = "Cluster API to node groups"
      protocol                      = "tcp"
      from_port                     = 443
      to_port                       = 443
      type                          = "ingress"
      source_cluster_security_group = "${aws_security_group.cluster.id}"
    }
    ingress_cluster_4443 = {
      description                   = "Cluster API to node 4443/tcp webhook"
      protocol                      = "tcp"
      from_port                     = 4443
      to_port                       = 4443
      type                          = "ingress"
      source_cluster_security_group = "${aws_security_group.cluster.id}"
    }
    ingress_cluster_6443 = {
      description                   = "Cluster API to node 6443/tcp webhook"
      protocol                      = "tcp"
      from_port                     = 6443
      to_port                       = 6443
      type                          = "ingress"
      source_cluster_security_group = "${aws_security_group.cluster.id}"
    }
    ingress_cluster_8443 = {
      description                   = "Cluster API to node 8443/tcp webhook"
      protocol                      = "tcp"
      from_port                     = 8443
      to_port                       = 8443
      type                          = "ingress"
      source_cluster_security_group = "${aws_security_group.cluster.id}"
    }
    ingress_cluster_9443 = {
      description                   = "Cluster API to node 9443/tcp webhook"
      protocol                      = "tcp"
      from_port                     = 9443
      to_port                       = 9443
      type                          = "ingress"
      source_cluster_security_group = "${aws_security_group.cluster.id}"
    }
    ingress_cluster_kubelet = {
      description                   = "Cluster API to node kubelets"
      protocol                      = "tcp"
      from_port                     = 10250
      to_port                       = 10250
      type                          = "ingress"
      source_cluster_security_group = "${aws_security_group.cluster.id}"
    }
    ingress_nodes = {
      description = "Node to node ingress on ephemeral ports"
      protocol    = "tcp"
      from_port   = 1025
      to_port     = 65535
      type        = "ingress"
      self        = true
    }
    ingress_coredns_tcp = {
      description = "Node to node CoreDNS TCP"
      protocol    = "tcp"
      from_port   = 53
      to_port     = 53
      type        = "ingress"
      self        = true
    }
    ingress_coredns_udp = {
      description = "Node to node CoreDNS UDP"
      protocol    = "udp"
      from_port   = 53
      to_port     = 53
      type        = "ingress"
      self        = true
    }
    egress = {
      description = "Allow all egress"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_security_group" "cluster" {
  name_prefix = "${local.cluster_sg_name}-"
  description = "${var.name} EKS cluster security group"
  vpc_id      = var.vpc_id

  tags = merge(local.tags, {
    Name = "${local.cluster_sg_name}"
  })
}

resource "aws_security_group_rule" "cluster" {
  for_each = local.cluster_security_group_rules

  security_group_id = aws_security_group.cluster.id
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  type              = each.value.type

  description              = lookup(each.value, "description", null)
  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(each.value, "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(each.value, "prefix_list_ids", null)
  self                     = lookup(each.value, "self", null)
  source_security_group_id = lookup(each.value, "source_node_security_group", null)
}

resource "aws_security_group" "node" {
  name_prefix = "${local.node_sg_name}-"
  description = "EKS cluster ${var.name} node group ${local.node_sg_name}"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      "Name"                              = local.node_sg_name
      "kubernetes.io/cluster/${var.name}" = "owned"
    },
    local.tags
  )
}

resource "aws_security_group_rule" "node" {
  for_each = merge(
    local.node_security_group_rules,
    var.node_security_group_additional_rules,
  )

  # Required
  security_group_id = aws_security_group.node.id
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

resource "aws_security_group_rule" "consul_tcp" {
  security_group_id = aws_eks_cluster.cluster.vpc_config.0.cluster_security_group_id
  protocol          = "tcp"
  from_port         = 8301
  to_port           = 8301
  type              = "ingress"
  cidr_blocks       = [var.hcp_network_cidr_block]
}

resource "aws_security_group_rule" "consul_udp" {
  security_group_id = aws_eks_cluster.cluster.vpc_config.0.cluster_security_group_id
  protocol          = "udp"
  from_port         = 8301
  to_port           = 8301
  type              = "ingress"
  cidr_blocks       = [var.hcp_network_cidr_block]
}

resource "aws_security_group_rule" "consul_mesh_gateway" {
  security_group_id = aws_eks_cluster.cluster.vpc_config.0.cluster_security_group_id
  protocol          = "tcp"
  from_port         = 8443
  to_port           = 8443
  type              = "ingress"
  cidr_blocks       = [var.hcp_network_cidr_block]
}

resource "aws_security_group_rule" "consul_mesh_gateway_envoy" {
  security_group_id = aws_eks_cluster.cluster.vpc_config.0.cluster_security_group_id
  protocol          = "tcp"
  from_port         = 20000
  to_port           = 22000
  type              = "ingress"
  cidr_blocks       = var.accessible_cidr_blocks
}
