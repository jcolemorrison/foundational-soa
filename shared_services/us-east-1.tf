# Network and Transit Gateway for us-east-1
module "network_us_east_1" {
  source = "./region"
  vpc_cidr_block = "10.0.0.0/22"
  region = "us-east-1"
  tgw_asn = 64512
  tgw_cidr_block = "10.0.4.0/22"
  organization_arn = data.aws_organizations_organization.current.arn
  external_principals = []
}

# Peering attachment accepter - us-west-2 to us-east-1
resource "aws_ec2_transit_gateway_peering_attachment_accepter" "us_east_1_to_us_west_2" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.us_east_1_to_us_west_2.id
}

# Peering attachment accepter - eu-west-1 to us-east-1
resource "aws_ec2_transit_gateway_peering_attachment_accepter" "us_east_1_to_eu_west_1" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.us_east_1_to_eu_west_1.id
}

### TGW Route - us-east-1 to us-west-2
resource "aws_ec2_transit_gateway_route" "us_east_1_to_us_west_2" {
  destination_cidr_block         = module.network_us_west_2.vpc_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.us_east_1_to_us_west_2.id
  transit_gateway_route_table_id = module.network_us_east_1.transit_gateway_route_table_id
}

### TGW Route - us-east-1 to eu-west-1
resource "aws_ec2_transit_gateway_route" "us_east_1_to_eu_west_1" {
  destination_cidr_block         = module.network_eu_west_1.vpc_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.us_east_1_to_eu_west_1.id
  transit_gateway_route_table_id = module.network_us_east_1.transit_gateway_route_table_id
}

### VPC Route - us-east-1 to us-west-2
resource "aws_route" "us_east_1_to_us_west_2_tgw_public" {
  destination_cidr_block = module.network_us_west_2.vpc_cidr_block
  route_table_id = module.network_us_east_1.vpc_public_route_table_id
  transit_gateway_id = module.network_us_east_1.transit_gateway_id
}

resource "aws_route" "us_east_1_to_us_west_2_tgw_private" {
  destination_cidr_block = module.network_us_west_2.vpc_cidr_block
  route_table_id = module.network_us_east_1.vpc_private_route_table_id
  transit_gateway_id = module.network_us_east_1.transit_gateway_id
}

### VPC Route - us-east-1 to eu-west-1
resource "aws_route" "us_east_1_to_eu_west_1_tgw_public" {
  destination_cidr_block = module.network_eu_west_1.vpc_cidr_block
  route_table_id = module.network_us_east_1.vpc_public_route_table_id
  transit_gateway_id = module.network_us_east_1.transit_gateway_id
}

resource "aws_route" "us_east_1_to_eu_west_1_tgw_private" {
  destination_cidr_block = module.network_eu_west_1.vpc_cidr_block
  route_table_id = module.network_us_east_1.vpc_private_route_table_id
  transit_gateway_id = module.network_us_east_1.transit_gateway_id
}