terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.23.1"
    }
  }
}

provider "aws" {
  region = var.aws_default_region
  default_tags {
    tags = var.aws_default_tags
  }
}

provider "aws" {
  region = "us-west-2"
  alias = "us_west_2"
  default_tags {
    tags = var.aws_default_tags
  }
}

provider "aws" {
  region = "eu-west-1"
  alias = "eu_west_1"
  default_tags {
    tags = var.aws_default_tags
  }
}

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

# Network and Transit Gateway for us-west-2
module "network_us_west_2" {
  source = "./region"
  vpc_cidr_block = "10.0.8.0/22"
  region = "us-west-2"
  tgw_asn = 64513
  tgw_cidr_block = "10.0.12.0/22"
  organization_arn = data.aws_organizations_organization.current.arn
  external_principals = []

  providers = {
    aws = aws.us_west_2
  }
}

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



# Network Peering Connections - us-east-1 to us-west-2
resource "aws_ec2_transit_gateway_peering_attachment" "us_east_1_to_us_west_2" {
  transit_gateway_id      = module.network_us_west_2.transit_gateway_id
  peer_region             = "us-east-1"
  peer_transit_gateway_id = module.network_us_east_1.transit_gateway_id

  provider = aws.us_west_2
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "us_east_1_to_us_west_2" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.us_east_1_to_us_west_2.id
}

### Route - us-west-2 routes to us-east-1
resource "aws_ec2_transit_gateway_route" "us_west_2_to_us_east_1" {
  destination_cidr_block         = module.network_us_east_1.vpc_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.us_east_1_to_us_west_2.id
  transit_gateway_route_table_id = module.network_us_west_2.transit_gateway_route_table_id

  provider = aws.us_west_2
}

### Route - us-east-1 routes to us-west-2
resource "aws_ec2_transit_gateway_route" "us_east_1_to_us_west_2" {
  destination_cidr_block         = module.network_us_west_2.vpc_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.us_east_1_to_us_west_2.id
  transit_gateway_route_table_id = module.network_us_east_1.transit_gateway_route_table_id
}



# Network Peering Connections - us-east-1 to eu-west-1
resource "aws_ec2_transit_gateway_peering_attachment" "us_east_1_to_eu_west_1" {
  transit_gateway_id      = module.network_eu_west_1.transit_gateway_id
  peer_region             = "us-east-1"
  peer_transit_gateway_id = module.network_us_east_1.transit_gateway_id

  provider = aws.eu_west_1
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "us_east_1_to_eu_west_1" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.us_east_1_to_eu_west_1.id
}

### Route - eu-west-1 to us-east-1
resource "aws_ec2_transit_gateway_route" "eu_west_1_to_us_east_1" {
  destination_cidr_block         = module.network_us_east_1.vpc_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.us_east_1_to_eu_west_1.id
  transit_gateway_route_table_id = module.network_eu_west_1.transit_gateway_route_table_id

  provider = aws.eu_west_1
}

### Route - us-east-1 to eu-west-1
resource "aws_ec2_transit_gateway_route" "us_east_1_to_eu_west_1" {
  destination_cidr_block         = module.network_eu_west_1.vpc_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.us_east_1_to_eu_west_1.id
  transit_gateway_route_table_id = module.network_us_east_1.transit_gateway_route_table_id
}



# Network Peering Connections - us-west-2 to eu-west-1
resource "aws_ec2_transit_gateway_peering_attachment" "us_west_2_to_eu_west_1" {
  transit_gateway_id      = module.network_eu_west_1.transit_gateway_id
  peer_region             = "us-west-2"
  peer_transit_gateway_id = module.network_us_west_2.transit_gateway_id

  provider = aws.eu_west_1
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "us_west_2_to_eu_west_1" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.us_west_2_to_eu_west_1.id

  provider = aws.us_west_2
}

### Route - eu-west-1 to us-west-2
resource "aws_ec2_transit_gateway_route" "eu_west_1_to_us_west_2" {
  destination_cidr_block         = module.network_us_west_2.vpc_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.us_west_2_to_eu_west_1.id
  transit_gateway_route_table_id = module.network_eu_west_1.transit_gateway_route_table_id

  provider = aws.eu_west_1
}

### Route - us-west-2 to eu-west-1
resource "aws_ec2_transit_gateway_route" "us_west_2_to_eu_west_1" {
  destination_cidr_block         = module.network_eu_west_1.vpc_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.us_west_2_to_eu_west_1.id
  transit_gateway_route_table_id = module.network_us_west_2.transit_gateway_route_table_id

  provider = aws.us_west_2
}