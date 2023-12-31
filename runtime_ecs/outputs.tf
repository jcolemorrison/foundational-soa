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

output "subdomain_name_servers" {
  value       = aws_route53_zone.subdomain.name_servers
  description = "list of name servers for the subdomain"
}

output "public_alb_dns_values" {
  value       = local.public_alb_dns_values
  description = "DNS names and Zone IDs of each regional public ALB that maps to its regional public API"
}