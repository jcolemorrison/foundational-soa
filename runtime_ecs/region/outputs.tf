output "keypair_name" {
  value       = aws_key_pair.boundary.key_name
  description = "Boundary worker keypair"
}

output "ssh_private_key" {
  value       = base64encode(tls_private_key.boundary.private_key_openssh)
  description = "Boundary worker SSH key"
  sensitive   = true
}

output "public_alb_dns_name" {
  value = aws_lb.public_alb.dns_name
  description = "DNS Name of regional public application load balancer for the ECS API"
}