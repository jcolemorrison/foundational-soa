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