data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  iam_role_path          = "${var.path_prefix}/${data.aws_region.current.name}/${var.name}/"
  iam_role_policy_prefix = "arn:${data.aws_partition.current.partition}:iam::aws:policy"
}

data "aws_iam_policy_document" "assume_role_policy_cluster" {
  statement {
    sid     = "EKSClusterAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

resource "aws_iam_role" "cluster" {
  name_prefix = "${var.name}-cluster-"
  path        = local.iam_role_path
  description = "${var.name} EKS cluster role"

  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy_cluster.json
  force_detach_policies = true

  inline_policy {
    name = "${var.name}-deny-log-group"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["logs:CreateLogGroup"]
          Effect   = "Deny"
          Resource = "*"
        },
      ]
    })
  }

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "cluster" {
  for_each = toset([
    "${local.iam_role_policy_prefix}/AmazonEKSClusterPolicy",
    "${local.iam_role_policy_prefix}/AmazonEKSVPCResourceController",
  ])

  policy_arn = each.value
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster_additional" {
  for_each = { for k, v in var.eks_cluster_iam_role_additional_policies : k => v }

  policy_arn = each.value
  role       = aws_iam_role.cluster.name
}