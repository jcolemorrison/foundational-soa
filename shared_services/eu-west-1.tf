# Network and Transit Gateway for eu-west-1
module "network_eu_west_1" {
  source = "./region"
  vpc_cidr_block = "10.0.16.0/22"
  region = "eu-west-1"
  tgw_asn = 64514
  tgw_cidr_block = "10.0.20.0/22"
  organization_arn = data.aws_organizations_organization.current.arn
  external_principals = []

  providers = {
    aws = aws.eu_west_1
  }
}

# Peering attachment request - eu-west-1 to us-east-1
resource "aws_ec2_transit_gateway_peering_attachment" "us_east_1_to_eu_west_1" {
  transit_gateway_id      = module.network_eu_west_1.transit_gateway_id
  peer_region             = "us-east-1"
  peer_transit_gateway_id = module.network_us_east_1.transit_gateway_id

  provider = aws.eu_west_1
}

# Peering attachment request - eu-west-1 to us-west-2
resource "aws_ec2_transit_gateway_peering_attachment" "us_west_2_to_eu_west_1" {
  transit_gateway_id      = module.network_eu_west_1.transit_gateway_id
  peer_region             = "us-west-2"
  peer_transit_gateway_id = module.network_us_west_2.transit_gateway_id

  provider = aws.eu_west_1
}

### TGW Route - eu-west-1 to us-east-1
resource "aws_ec2_transit_gateway_route" "eu_west_1_to_us_east_1" {
  destination_cidr_block         = module.network_us_east_1.vpc_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.us_east_1_to_eu_west_1.id
  transit_gateway_route_table_id = module.network_eu_west_1.transit_gateway_route_table_id

  provider = aws.eu_west_1
}

### TGW Route - eu-west-1 to us-west-2
resource "aws_ec2_transit_gateway_route" "eu_west_1_to_us_west_2" {
  destination_cidr_block         = module.network_us_west_2.vpc_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.us_west_2_to_eu_west_1.id
  transit_gateway_route_table_id = module.network_eu_west_1.transit_gateway_route_table_id

  provider = aws.eu_west_1
}

### VPC Route - eu-west-1 to us-east-1
resource "aws_route" "eu_west_1_to_us_east_1_tgw_public" {
  destination_cidr_block = module.network_us_east_1.vpc_cidr_block
  route_table_id = module.network_eu_west_1.vpc_public_route_table_id
  transit_gateway_id = module.network_eu_west_1.transit_gateway_id

  provider = aws.eu_west_1
}

resource "aws_route" "eu_west_1_to_us_east_1_tgw_private" {
  destination_cidr_block = module.network_us_east_1.vpc_cidr_block
  route_table_id = module.network_eu_west_1.vpc_private_route_table_id
  transit_gateway_id = module.network_eu_west_1.transit_gateway_id

  provider = aws.eu_west_1
}


### VPC Route - eu-west-1 to us-west-2
resource "aws_route" "eu_west_1_to_us_west_2_tgw_public" {
  destination_cidr_block = module.network_us_west_2.vpc_cidr_block
  route_table_id = module.network_eu_west_1.vpc_public_route_table_id
  transit_gateway_id = module.network_eu_west_1.transit_gateway_id

  provider = aws.eu_west_1
}

resource "aws_route" "eu_west_1_to_us_west_2_tgw_private" {
  destination_cidr_block = module.network_us_west_2.vpc_cidr_block
  route_table_id = module.network_eu_west_1.vpc_private_route_table_id
  transit_gateway_id = module.network_eu_west_1.transit_gateway_id

  provider = aws.eu_west_1
}