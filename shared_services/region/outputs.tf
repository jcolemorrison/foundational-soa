output "transit_gateway_id" {
  description = "ID of the transit gateway."
  value = aws_ec2_transit_gateway.main.id
}

output "transit_gateway_route_table_id" {
  description = "ID of the transit gateway's default route table."
  value = aws_ec2_transit_gateway.main.association_default_route_table_id
}

output "transit_gateway_cidr_block" {
  description = "CIDR Block of the transit gateway."
  value = one(aws_ec2_transit_gateway.main.transit_gateway_cidr_blocks)
}

output "vpc_id" {
  description = "ID of the VPC"
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "IPv4 CIDR Block of the VPC."
  value = module.vpc.vpc_cidr_block
}

output "vpc_public_subnet_ids" {
  description = "IDs of the VPC's public subnets."
  value = module.vpc.public_subnet_ids
}

output "vpc_public_route_table_id" {
  description = "ID of the VPC's public route table."
  value = module.vpc.public_route_table_id
}

output "vpc_private_route_table_id" {
  description = "ID of the VPC's private route table."
  value = module.vpc.private_route_table_id
}