locals {
  eu_west_1 = "eu-west-1"
}

# Network and Transit Gateway for eu-west-1
module "network_eu_west_1" {
  source              = "./region"
  vpc_cidr_block      = "10.0.16.0/22"
  region              = "eu-west-1"
  tgw_asn             = 64514
  tgw_cidr_block      = "10.0.20.0/22"
  organization_arn    = data.aws_organizations_organization.current.arn
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
  route_table_id         = module.network_eu_west_1.vpc_public_route_table_id
  transit_gateway_id     = module.network_eu_west_1.transit_gateway_id

  provider = aws.eu_west_1
}

resource "aws_route" "eu_west_1_to_us_east_1_tgw_private" {
  destination_cidr_block = module.network_us_east_1.vpc_cidr_block
  route_table_id         = module.network_eu_west_1.vpc_private_route_table_id
  transit_gateway_id     = module.network_eu_west_1.transit_gateway_id

  provider = aws.eu_west_1
}


### VPC Route - eu-west-1 to us-west-2
resource "aws_route" "eu_west_1_to_us_west_2_tgw_public" {
  destination_cidr_block = module.network_us_west_2.vpc_cidr_block
  route_table_id         = module.network_eu_west_1.vpc_public_route_table_id
  transit_gateway_id     = module.network_eu_west_1.transit_gateway_id

  provider = aws.eu_west_1
}

resource "aws_route" "eu_west_1_to_us_west_2_tgw_private" {
  destination_cidr_block = module.network_us_west_2.vpc_cidr_block
  route_table_id         = module.network_eu_west_1.vpc_private_route_table_id
  transit_gateway_id     = module.network_eu_west_1.transit_gateway_id

  provider = aws.eu_west_1
}

# HCP Consul and Vault clusters - secondary. Boundary cluster is one per HCP project.
module "hcp_eu_west_1" {
  source = "./modules/hcp"

  hvn_name       = local.eu_west_1
  hvn_region     = local.eu_west_1
  hvn_cidr_block = "172.25.24.0/22"

  aws_ram_resource_share_arn = module.network_eu_west_1.transit_gateway_resource_share_arn
  transit_gateway_arn        = module.network_eu_west_1.transit_gateway_arn
  transit_gateway_id         = module.network_eu_west_1.transit_gateway_id

  vpc_cidr_blocks = {
    shared = module.network_eu_west_1.vpc_cidr_block
    ec2    = local.runtime_ec2
    ecs    = local.runtime_ecs
    eks    = local.runtime_eks_eu_west_1
  }

  hcp_consul_name            = "${local.prefix}-${local.eu_west_1}"
  hcp_consul_tier            = "plus"
  hcp_consul_public_endpoint = true

  hcp_vault_name            = "${local.prefix}-${local.eu_west_1}"
  hcp_vault_tier            = "plus_small"
  hcp_vault_public_endpoint = true
  hcp_vault_primary_link    = module.hcp_us_east_1.hcp_vault.self_link

  providers = {
    aws = aws.eu_west_1
  }
}


### VPC Route - us-west-2 to HashiCorp Cloud Platform Virtual Network
resource "aws_route" "eu_west_1_to_hvn_tgw_public" {
  destination_cidr_block = module.hcp_eu_west_1.hvn_cidr_block
  route_table_id         = module.network_eu_west_1.vpc_public_route_table_id
  transit_gateway_id     = module.network_eu_west_1.transit_gateway_id

  provider = aws.eu_west_1
}

resource "aws_route" "eu_west_1_to_hvn_tgw_private" {
  destination_cidr_block = module.hcp_eu_west_1.hvn_cidr_block
  route_table_id         = module.network_eu_west_1.vpc_private_route_table_id
  transit_gateway_id     = module.network_eu_west_1.transit_gateway_id

  provider = aws.eu_west_1
}

### Set up peering connection between eu-west-1 and us-west-2
### Not required for us-east-1 because HCP Vault performance replication
### handles it.
resource "hcp_hvn_peering_connection" "eu_west_1_to_us_west_2" {
  hvn_1 = module.hcp_eu_west_1.hvn_self_link
  hvn_2 = module.hcp_us_west_2.hvn_self_link
}