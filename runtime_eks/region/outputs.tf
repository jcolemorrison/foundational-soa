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

output "database" {
  value = var.create_database ? {
    address  = module.database.0.address
    port     = module.database.0.port
    username = module.database.0.username
    password = module.database.0.password
    dbname   = module.database.0.dbname
  } : null
  description = "Database attributes"
  sensitive   = true
}

output "database_security_group_id" {
  value       = var.create_database ? module.database.0.security_group_id : null
  description = "Database security group ID"
}

output "database_kms_key_id" {
  value       = var.create_database ? module.database.0.kms_key_id : null
  description = "Database KMS key ID"
}
