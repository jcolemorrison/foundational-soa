# Network and Transit Gateway for us-west-2
module "network_us_west_2" {
  source              = "./region"
  vpc_cidr_block      = "10.0.8.0/22"
  region              = "us-west-2"
  tgw_asn             = 64513
  tgw_cidr_block      = "10.0.12.0/22"
  organization_arn    = data.aws_organizations_organization.current.arn
  external_principals = []

  providers = {
    aws = aws.us_west_2
  }
}

# Peering attachment accepter - us-west-2 to eu-west-1
resource "aws_ec2_transit_gateway_peering_attachment_accepter" "us_west_2_to_eu_west_1" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.us_west_2_to_eu_west_1.id

  provider = aws.us_west_2
}

# Peering attachment request - us-west-2 to us-east-1
resource "aws_ec2_transit_gateway_peering_attachment" "us_east_1_to_us_west_2" {
  transit_gateway_id      = module.network_us_west_2.transit_gateway_id
  peer_region             = "us-east-1"
  peer_transit_gateway_id = module.network_us_east_1.transit_gateway_id

  provider = aws.us_west_2
}

### TGW Route - us-west-2 routes to us-east-1
resource "aws_ec2_transit_gateway_route" "us_west_2_to_us_east_1" {
  destination_cidr_block         = module.network_us_east_1.vpc_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.us_east_1_to_us_west_2.id
  transit_gateway_route_table_id = module.network_us_west_2.transit_gateway_route_table_id

  provider = aws.us_west_2
}

### TGW Route - us-west-2 to eu-west-1
resource "aws_ec2_transit_gateway_route" "us_west_2_to_eu_west_1" {
  destination_cidr_block         = module.network_eu_west_1.vpc_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.us_west_2_to_eu_west_1.id
  transit_gateway_route_table_id = module.network_us_west_2.transit_gateway_route_table_id

  provider = aws.us_west_2
}

### VPC Route - us-west-2 to us-east-1
resource "aws_route" "us_west_2_to_us_east_1_tgw_public" {
  destination_cidr_block = module.network_us_east_1.vpc_cidr_block
  route_table_id         = module.network_us_west_2.vpc_public_route_table_id
  transit_gateway_id     = module.network_us_west_2.transit_gateway_id

  provider = aws.us_west_2
}

resource "aws_route" "us_west_2_to_us_east_1_tgw_private" {
  destination_cidr_block = module.network_us_east_1.vpc_cidr_block
  route_table_id         = module.network_us_west_2.vpc_private_route_table_id
  transit_gateway_id     = module.network_us_west_2.transit_gateway_id

  provider = aws.us_west_2
}

### VPC Route - us-west-2 to eu-west-1
resource "aws_route" "us_west_2_to_eu_west_1_tgw_public" {
  destination_cidr_block = module.network_eu_west_1.vpc_cidr_block
  route_table_id         = module.network_us_west_2.vpc_public_route_table_id
  transit_gateway_id     = module.network_us_west_2.transit_gateway_id

  provider = aws.us_west_2
}

resource "aws_route" "us_west_2_to_eu_west_1_tgw_private" {
  destination_cidr_block = module.network_eu_west_1.vpc_cidr_block
  route_table_id         = module.network_us_west_2.vpc_private_route_table_id
  transit_gateway_id     = module.network_us_west_2.transit_gateway_id

  provider = aws.us_west_2
}