resource "aws_kms_key" "cluster" {
  description             = "${var.name} EKS cluster's KMS key for encryption"
  deletion_window_in_days = 7

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:*"
        ]
        Effect = "Allow"
        Principal = {
          AWS = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Resource = "*"
        Sid      = "Default"
      },
      {
        Action = [
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Encrypt",
          "kms:DescribeKey",
          "kms:Decrypt",
        ]
        Effect = "Allow"
        Principal = {
          AWS = "${aws_iam_role.cluster.arn}"
        }
        Resource = "*"
        Sid      = "KeyUsage"
      },
    ]
    Version = "2012-10-17"
  })

  tags = local.tags
}

resource "aws_kms_alias" "cluster" {
  name          = "alias/eks/${var.name}"
  target_key_id = aws_kms_key.cluster.key_id
}

resource "aws_iam_policy" "cluster_encryption" {
  description = "Cluster encryption policy"
  name_prefix = "${var.name}-cluster-encryption-"
  path        = local.iam_role_path
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ListGrants",
            "kms:DescribeKey",
          ]
          Effect   = "Allow"
          Resource = "${aws_kms_key.cluster.arn}"
        },
      ]
      Version = "2012-10-17"
    }
  )

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "cluster_encryption" {
  policy_arn = aws_iam_policy.cluster_encryption.arn
  role       = aws_iam_role.cluster.name
}

data "tls_certificate" "cluster" {
  url = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.${data.aws_partition.current.dns_suffix}"]
  thumbprint_list = [data.tls_certificate.cluster.certificates.0.sha1_fingerprint]
  url             = aws_eks_cluster.cluster.identity.0.oidc.0.issuer

  tags = merge(
    { Name = "${var.name}-eks-irsa" },
    local.tags
  )
}

resource "aws_eks_cluster" "cluster" {
  name     = var.name
  role_arn = aws_iam_role.cluster.arn

  version = var.cluster_version

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
  ]

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    security_group_ids      = concat(var.cluster_additional_security_group_ids, [aws_security_group.cluster.id])
  }

  encryption_config {
    provider {
      key_arn = aws_kms_key.cluster.arn
    }
    resources = ["secrets"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster,
    aws_kms_key.cluster
  ]
}
