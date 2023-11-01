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
  name        = "${var.name}-NodeGroup"
  path        = local.iam_role_path
  description = "${var.name} EKS cluster node group role"

  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy_node_group.json
  force_detach_policies = true

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "node_group" {
  for_each = toset([
    "${local.iam_role_policy_prefix}/AmazonEKSWorkerNodePolicy",
    "${local.iam_role_policy_prefix}/AmazonEC2ContainerRegistryReadOnly",
    "${local.iam_role_policy_prefix}/AmazonEKS_CNI_Policy",
  ])

  policy_arn = each.value
  role       = aws_iam_role.node_group.name
}

resource "aws_iam_role_policy_attachment" "node_group_additional" {
  for_each = var.node_group_iam_role_additional_policies

  policy_arn = each.value
  role       = aws_iam_role.node_group.name
}

data "aws_ssm_parameter" "eks_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.cluster.version}/amazon-linux-2/recommended/release_version"
}

# resource "aws_eks_node_group" "node_group" {
#   depends_on = [
#     aws_iam_role_policy_attachment.node_group
#   ]
#   cluster_name  = var.name
#   node_role_arn = aws_iam_role.node_group.arn
#   subnet_ids    = var.private_subnet_ids

#   capacity_type  = var.node_group_config.capacity_type
#   ami_type       = var.node_group_config.ami_type
#   instance_types = var.node_group_config.instance_types

#   scaling_config {
#     min_size     = var.node_group_config.min_size
#     max_size     = var.node_group_config.max_size
#     desired_size = var.node_group_config.desired_size
#   }

#   update_config {
#     max_unavailable = var.node_group_config.max_unavailable
#   }

#   node_group_name = var.node_group_config.name

#   release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_release_version.value)
#   version         = var.cluster_version


#   labels = var.node_group_config.labels

#   dynamic "remote_access" {
#     for_each = length(var.remote_access) > 0 ? [var.remote_access] : []

#     content {
#       ec2_ssh_key               = try(remote_access.value.ec2_ssh_key, null)
#       source_security_group_ids = try(remote_access.value.source_security_group_ids, [])
#     }
#   }

#   tags = local.tags
# }