output "default_region" {
  value       = data.aws_region.current
  description = "default region of deployment in AWS"
}

output "hcp_us_east_1" {
  value = {
    boundary = module.hcp_us_east_1.hcp_boundary
    vault    = module.hcp_us_east_1.hcp_vault
    consul   = module.hcp_us_east_1.hcp_consul
  }
  sensitive   = true
  description = "HCP Consul, Vault, and Boundary attributes for us-east-1"
}

output "hcp_us_west_2" {
  value = {
    boundary = module.hcp_us_west_2.hcp_boundary
    vault    = module.hcp_us_west_2.hcp_vault
    consul   = module.hcp_us_west_2.hcp_consul
  }
  sensitive   = true
  description = "HCP Consul and Vault attributes for us-west-2"
}

output "hcp_eu_west_1" {
  value = {
    boundary = module.hcp_eu_west_1.hcp_boundary
    vault    = module.hcp_eu_west_1.hcp_vault
    consul   = module.hcp_eu_west_1.hcp_consul
  }
  sensitive   = true
  description = "HCP Consul and Vault attributes for eu-west-1"
}