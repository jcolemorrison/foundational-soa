locals {
  us_west_2 = "us-west-2"
}

# Network and Transit Gateway for us-west-2
module "network_us_west_2" {
  source              = "./region"
  vpc_cidr_block      = "10.0.8.0/22"
  region              = local.us_west_2
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

resource "aws_ec2_transit_gateway_route" "us_west_2_to_runtime_eks_eu_west_1" {
  destination_cidr_block         = local.runtime_eks_eu_west_1
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

# HCP Consul and Vault clusters - secondary. Boundary cluster is one per HCP project.
module "hcp_us_west_2" {
  source = "./modules/hcp"

  hvn_name       = local.us_west_2
  hvn_region     = local.us_west_2
  hvn_cidr_block = "172.25.20.0/22"

  aws_ram_resource_share_arn = module.network_us_west_2.transit_gateway_resource_share_arn
  transit_gateway_arn        = module.network_us_west_2.transit_gateway_arn
  transit_gateway_id         = module.network_us_west_2.transit_gateway_id

  vpc_cidr_blocks = {
    shared = module.network_us_west_2.vpc_cidr_block
    ec2    = local.runtime_ec2_us_west_2
    ecs    = local.runtime_ecs_us_west_2
    eks    = local.runtime_eks_us_west_2
  }


  hcp_consul_name            = "${local.prefix}-${local.us_west_2}"
  hcp_consul_tier            = "plus"
  hcp_consul_public_endpoint = true

  hcp_vault_name            = "${local.prefix}-${local.us_west_2}"
  hcp_vault_tier            = "plus_small"
  hcp_vault_public_endpoint = true
  hcp_vault_primary_link    = module.hcp_us_east_1.hcp_vault.self_link

  providers = {
    aws = aws.us_west_2
  }
}


### VPC Route - us-west-2 to HashiCorp Cloud Platform Virtual Network
resource "aws_route" "us_west_2_to_hvn_tgw_public" {
  destination_cidr_block = module.hcp_us_west_2.hvn_cidr_block
  route_table_id         = module.network_us_west_2.vpc_public_route_table_id
  transit_gateway_id     = module.network_us_west_2.transit_gateway_id

  provider = aws.us_west_2
}

resource "aws_route" "us_west_2_to_hvn_tgw_private" {
  destination_cidr_block = module.hcp_us_west_2.hvn_cidr_block
  route_table_id         = module.network_us_west_2.vpc_private_route_table_id
  transit_gateway_id     = module.network_us_west_2.transit_gateway_id

  provider = aws.us_west_2
}