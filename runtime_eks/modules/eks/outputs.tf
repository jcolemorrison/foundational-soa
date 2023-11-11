output "eks_cluster_security_group" {
  value       = aws_eks_cluster.cluster.vpc_config.0.cluster_security_group_id
  description = "Primary EKS cluster security group"
}