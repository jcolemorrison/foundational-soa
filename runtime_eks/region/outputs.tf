output "keypair_name" {
  value       = aws_key_pair.boundary.key_name
  description = "Boundary worker keypair"
}

output "ssh_private_key" {
  value       = base64encode(tls_private_key.boundary.private_key_openssh)
  description = "Boundary worker SSH key"
  sensitive   = true
}

output "irsa" {
  value       = var.create_eks_cluster ? module.eks.0.irsa : null
  description = "EKS IRSA attributes for AWS LB controller"
}

output "vpc_id" {
  value       = module.network.vpc_id
  description = "VPC ID for runtime"
}

output "private_subnets_ids" {
  value       = module.vpc.private_subnet_ids
  description = "Private subnets for runtime"
}
