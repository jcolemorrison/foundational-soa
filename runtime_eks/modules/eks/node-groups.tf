data "aws_iam_policy_document" "assume_role_policy_node_group" {
  statement {
    sid     = "EKSNodeAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

resource "aws_iam_role" "node_group" {
  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy_node_group.json
  description           = "EKS managed node group IAM role"
  force_detach_policies = true
  name_prefix           = "${var.name}-eks-node-group-"

  tags = local.tags
}

locals {
  node_group_policies = [
    "${local.iam_role_policy_prefix}/AmazonEKSWorkerNodePolicy",
    "${local.iam_role_policy_prefix}/AmazonEC2ContainerRegistryReadOnly",
    "${local.iam_role_policy_prefix}/AmazonEKS_CNI_Policy",
  ]
}

resource "aws_iam_role_policy_attachment" "node_group" {
  count = length(local.node_group_policies)

  policy_arn = local.node_group_policies[count.index]
  role       = aws_iam_role.node_group.name
}

resource "aws_iam_role_policy_attachment" "node_group_additional" {
  for_each = var.node_group_iam_role_additional_policies

  policy_arn = each.value
  role       = aws_iam_role.node_group.name
}

resource "aws_eks_node_group" "node_group" {
  ami_type               = var.node_group_config.ami_type
  capacity_type          = var.node_group_config.capacity_type
  cluster_name           = aws_eks_cluster.cluster.name
  disk_size              = var.node_group_config.disk_size
  instance_types         = var.node_group_config.instance_types
  labels                 = var.node_group_config.labels
  node_group_name_prefix = "${var.name}-"
  node_role_arn          = aws_iam_role.node_group.arn
  subnet_ids             = var.private_subnet_ids
  tags                   = local.tags
  version                = var.cluster_version

  dynamic "remote_access" {
    for_each = var.remote_access != null ? toset([var.remote_access]) : []
    content {
      ec2_ssh_key               = remote_access.value.ec2_ssh_key
      source_security_group_ids = remote_access.value.source_security_group_ids
    }
  }

  scaling_config {
    desired_size = var.node_group_config.desired_size
    max_size     = var.node_group_config.max_size
    min_size     = var.node_group_config.min_size
  }

  update_config {
    max_unavailable = var.node_group_config.max_unavailable
  }
}
