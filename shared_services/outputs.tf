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
  sensitive = true
}