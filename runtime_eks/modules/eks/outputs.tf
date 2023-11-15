output "eks_cluster_security_group" {
  value       = aws_eks_cluster.cluster.vpc_config.0.cluster_security_group_id
  description = "Primary EKS cluster security group"
}

output "irsa" {
  value = {
    service_account = var.service_account
    role_arn        = aws_iam_role.irsa.arn
    namespace       = var.namespace
  }
  description = "IAM Role service account information for AWS LB Controller"
}
