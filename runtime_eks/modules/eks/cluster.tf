resource "aws_kms_key" "cluster" {
  description             = "${var.name} EKS cluster's KMS key for encryption"
  deletion_window_in_days = 7
  policy                  = data.aws_iam_policy_document.eks_kms.json
  tags                    = local.tags
}

resource "aws_kms_alias" "cluster" {
  name          = "alias/${var.name}-cluster-key"
  target_key_id = aws_kms_key.cluster.key_id
}

resource "aws_iam_policy" "cluster_encryption" {
  name        = local.cluster_encryption_policy_name
  description = "${var.name} EKS cluster encryption role"
  path        = local.iam_role_path

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ListGrants",
          "kms:DescribeKey",
        ]
        Effect   = "Allow"
        Resource = aws_kms_key.cluster.arn
      },
    ]
  })

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "cluster_encryption" {
  policy_arn = aws_iam_policy.cluster_encryption.arn
  role       = aws_iam_role.cluster.name
}

resource "aws_eks_cluster" "cluster" {
  name     = var.name
  role_arn = aws_iam_role.cluster.arn

  version = var.cluster_version

  vpc_config {
    subnet_ids              = concat(var.private_subnet_ids, var.public_subnet_ids)
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    security_group_ids      = concat(var.cluster_additional_security_group_ids, [aws_security_group.cluster.id, aws_security_group.node.id])
  }

  encryption_config {
    provider {
      key_arn = aws_kms_key.cluster.arn
    }
    resources = ["secrets"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster
  ]
}