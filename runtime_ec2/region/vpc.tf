# VPC
module "vpc" {
  source     = "../../modules/vpc"
  cidr_block = var.vpc_cidr_block
  name       = "${var.region}-network"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  vpc_id             = module.vpc.id
  subnet_ids         = module.vpc.public_subnet_ids
  transit_gateway_id = var.transit_gateway_id
}

### VPC Route to Shared Services
resource "aws_route" "shared_services_public" {
  destination_cidr_block = var.shared_services_cidr_block
  route_table_id         = module.vpc.public_route_table_id
  transit_gateway_id     = var.transit_gateway_id
}

resource "aws_route" "shared_services_private" {
  destination_cidr_block = var.shared_services_cidr_block
  route_table_id         = module.vpc.private_route_table_id
  transit_gateway_id     = var.transit_gateway_id
}

### VPC Route to HCP HVN
resource "aws_route" "hcp_hvn_public" {
  destination_cidr_block = var.hcp_hvn_cidr_block
  route_table_id         = module.vpc.public_route_table_id
  transit_gateway_id     = var.transit_gateway_id
}

resource "aws_route" "hcp_hvn_private" {
  destination_cidr_block = var.hcp_hvn_cidr_block
  route_table_id         = module.vpc.private_route_table_id
  transit_gateway_id     = var.transit_gateway_id
}