locals {
  us_east_1 = "us-east-1"
}

# Network and Transit Gateway for us-east-1
module "network_us_east_1" {
  source              = "./region"
  vpc_cidr_block      = "10.0.0.0/22"
  region              = local.us_east_1
  tgw_asn             = 64512
  tgw_cidr_block      = "10.0.4.0/22"
  organization_arn    = data.aws_organizations_organization.current.arn
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

resource "aws_ec2_transit_gateway_route" "us_east_1_to_runtime_eks_us_west_2" {
  destination_cidr_block         = local.runtime_eks_us_west_2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.us_east_1_to_us_west_2.id
  transit_gateway_route_table_id = module.network_us_east_1.transit_gateway_route_table_id
}

resource "aws_ec2_transit_gateway_route" "us_east_1_to_runtime_ecs_us_west_2" {
  destination_cidr_block         = local.runtime_ecs_us_west_2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.us_east_1_to_us_west_2.id
  transit_gateway_route_table_id = module.network_us_east_1.transit_gateway_route_table_id
}

### TGW Route - us-east-1 to eu-west-1
resource "aws_ec2_transit_gateway_route" "us_east_1_to_eu_west_1" {
  destination_cidr_block         = module.network_eu_west_1.vpc_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.us_east_1_to_eu_west_1.id
  transit_gateway_route_table_id = module.network_us_east_1.transit_gateway_route_table_id
}

resource "aws_ec2_transit_gateway_route" "us_east_1_to_runtime_ecs_eu_west_1" {
  destination_cidr_block         = local.runtime_ecs_eu_west_1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.us_east_1_to_eu_west_1.id
  transit_gateway_route_table_id = module.network_us_east_1.transit_gateway_route_table_id
}

### VPC Route - us-east-1 to us-west-2
resource "aws_route" "us_east_1_to_us_west_2_tgw_public" {
  destination_cidr_block = module.network_us_west_2.vpc_cidr_block
  route_table_id         = module.network_us_east_1.vpc_public_route_table_id
  transit_gateway_id     = module.network_us_east_1.transit_gateway_id
}

resource "aws_route" "us_east_1_to_us_west_2_tgw_private" {
  destination_cidr_block = module.network_us_west_2.vpc_cidr_block
  route_table_id         = module.network_us_east_1.vpc_private_route_table_id
  transit_gateway_id     = module.network_us_east_1.transit_gateway_id
}

### VPC Route - us-east-1 to eu-west-1
resource "aws_route" "us_east_1_to_eu_west_1_tgw_public" {
  destination_cidr_block = module.network_eu_west_1.vpc_cidr_block
  route_table_id         = module.network_us_east_1.vpc_public_route_table_id
  transit_gateway_id     = module.network_us_east_1.transit_gateway_id
}

resource "aws_route" "us_east_1_to_eu_west_1_tgw_private" {
  destination_cidr_block = module.network_eu_west_1.vpc_cidr_block
  route_table_id         = module.network_us_east_1.vpc_private_route_table_id
  transit_gateway_id     = module.network_us_east_1.transit_gateway_id
}

# HCP Consul, Vault, and Boundary clusters - primary
module "hcp_us_east_1" {
  source = "./modules/hcp"

  hvn_name       = local.us_east_1
  hvn_region     = local.us_east_1
  hvn_cidr_block = "172.25.16.0/22"

  aws_ram_resource_share_arn = module.network_us_east_1.transit_gateway_resource_share_arn
  transit_gateway_arn        = module.network_us_east_1.transit_gateway_arn
  transit_gateway_id         = module.network_us_east_1.transit_gateway_id
  vpc_cidr_blocks = {
    shared = module.network_us_east_1.vpc_cidr_block
    ec2    = local.runtime_ec2_us_east_1
    ecs    = local.runtime_ecs_us_east_1
    eks    = local.runtime_eks_us_east_1
  }

  hcp_consul_name            = "${local.prefix}-${local.us_east_1}"
  hcp_consul_tier            = "plus"
  hcp_consul_public_endpoint = true

  hcp_vault_name            = "${local.prefix}-${local.us_east_1}"
  hcp_vault_tier            = "plus_small"
  hcp_vault_public_endpoint = true

  hcp_boundary_name = "${local.prefix}-${local.us_east_1}"
}

### VPC Route - us-east-1 to HashiCorp Cloud Platform Virtual Network
resource "aws_route" "us_east_1_to_hvn_tgw_public" {
  destination_cidr_block = module.hcp_us_east_1.hvn_cidr_block
  route_table_id         = module.network_us_east_1.vpc_public_route_table_id
  transit_gateway_id     = module.network_us_east_1.transit_gateway_id
}

resource "aws_route" "us_east_1_to_hvn_tgw_private" {
  destination_cidr_block = module.hcp_us_east_1.hvn_cidr_block
  route_table_id         = module.network_us_east_1.vpc_private_route_table_id
  transit_gateway_id     = module.network_us_east_1.transit_gateway_id
}