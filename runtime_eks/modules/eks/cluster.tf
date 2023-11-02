resource "aws_kms_key" "cluster" {
  description             = "${var.name} EKS cluster's KMS key for encryption"
  deletion_window_in_days = 7

  policy = data.aws_iam_policy_document.kms.json

  tags = local.tags
}

resource "aws_kms_alias" "cluster" {
  name          = "alias/eks/${var.name}"
  target_key_id = aws_kms_key.cluster.key_id
}



data "aws_iam_policy_document" "kms" {
  statement {
    sid       = "Default"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    sid = "KeyAdministration"
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
      "kms:ReplicateKey",
      "kms:ImportKeyMaterial"
    ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["${data.aws_iam_session_context.current.issuer_arn}"]
    }
  }

  statement {
    sid = "KeyUsage"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_role.cluster.arn}"]
    }
  }
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

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "vpc-cni"
}
