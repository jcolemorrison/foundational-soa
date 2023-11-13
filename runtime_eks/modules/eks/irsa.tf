resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.${data.aws_partition.current.dns_suffix}"]
  thumbprint_list = [data.tls_certificate.cluster.certificates.0.sha1_fingerprint]
  url             = aws_eks_cluster.cluster.identity.0.oidc.0.issuer

  tags = merge(
    { Name = "${var.name}-eks-irsa" },
    local.tags
  )
}

locals {
  oidc = {
    arn = aws_iam_openid_connect_provider.oidc_provider.arn
    url = replace(aws_iam_openid_connect_provider.oidc_provider.url, "https://", "")
    fully_qualified_audiences = "sts.amazonaws.com"
    fully_qualified_subjects  = join(":", ["system:serviceaccount", var.namespace, var.service_account])
  }
}

resource "aws_iam_policy" "lb_controller" {
  name_prefix = "${var.name}-lb-controller-"
  description = format("Allow aws-load-balancer-controller to manage AWS resources")
  policy      = file("${path.module}/policies/lb-controller.json")
}

resource "aws_iam_role" "irsa" {
  name_prefix = "${var.name}-eks-irsa-"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = local.oidc.arn
      }
      Condition = {
        StringEquals = {
          format("%s:sub", local.oidc.url) = local.oidc.fully_qualified_subjects
        }
      }
    }]
    Version = "2012-10-17"
  })

  tags = merge(
    { Name = "${var.name}-eks-irsa" },
    local.tags
  )
}

resource "aws_iam_role_policy_attachment" "irsa" {
  policy_arn = aws_iam_policy.lb_controller.arn
  role       = aws_iam_role.irsa.name
}