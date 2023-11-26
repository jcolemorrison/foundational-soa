output "default_region" {
  value = data.aws_region.current
  description = "default region of deployment in AWS"
}

output "subdomain_name_servers" {
  value       = aws_route53_zone.frontend.name_servers
  description = "list of name servers for the frontend subdomain"
}