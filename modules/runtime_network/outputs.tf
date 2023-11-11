output "vpc_id" {
  value       = module.vpc.id
  description = "ID of the VPC"
}

output "vpc_arn" {
  value       = module.vpc.arn
  description = "ARN of the VPC"
}

output "vpc_cidr_block" {
  value       = module.vpc.cidr_block
  description = "IPv4 CIDR block of the VPC"
}

output "vpc_ipv6_cidr_block" {
  value       = try(module.vpc.ipv6_cidr_block, null)
  description = "IPv6 CIDR block of the VPC"
}

output "vpc_public_route_table_id" {
  value       = module.vpc.public_route_table_id
  description = "ID of the VPC's public route table"
}

output "vpc_private_route_table_id" {
  value       = module.vpc.private_route_table_id
  description = "ID of the VPC's private route table"
}

output "vpc_public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
  description = "List of public subnet IDs"
}

output "vpc_private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "List of private subnet IDs"
}

output "transit_gateway_vpc_attachment_id" {
  value       = aws_ec2_transit_gateway_vpc_attachment.main.id
  description = "ID of the transit gateway VPC attachment"
}
