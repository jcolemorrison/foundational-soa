output "default_region" {
  value       = data.aws_region.current
  description = "default region of deployment in AWS"
}

output "ssh_keys" {
  value = {
    us_east_1 = module.us_east_1.ssh_private_key
    us_west_2 = module.us_west_2.ssh_private_key
    eu_west_1 = module.eu_west_1.ssh_private_key
  }
  description = "SSH Keys for Boundary workers"
  sensitive   = true
}

output "cluster_name" {
  value       = local.name
  description = "Name of EKS cluster name"
}

output "irsa" {
  value = {
    us_east_1 = module.us_east_1.irsa
    us_west_2 = module.us_west_2.irsa
    eu_west_1 = module.eu_west_1.irsa
  }
  description = "IAM Role service account attributes for AWS LB controller"
}

output "vault_database" {
  value = {
    namespace = vault_namespace.database.id
    path      = module.database_vault.0.database_secrets_path
    role      = module.database_vault.0.database_secrets_role
    policy    = module.database_vault.0.database_secrets_policies.read
  }
  description = "Vault database secrets role"
  sensitive   = true
}

output "certificate_arns" {
  value = {
    us_east_1 = module.us_east_1.certificate_arn
    us_west_2 = module.us_west_2.certificate_arn
    eu_west_1 = module.eu_west_1.certificate_arn
  }
  description = "Certificates for load balancer"
}

output "subdomain_name_servers" {
  value       = aws_route53_zone.subdomain.name_servers
  description = "list of name servers for the subdomain"
}
