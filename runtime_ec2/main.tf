locals {
  us_east_1 = "us-east-1"
  us_west_2 = "us-west-2"
  transit_gateway_ids = data.terraform_remote_state.shared_services.outputs.transit_gateway_ids
  shared_services_cidr_blocks = data.terraform_remote_state.shared_services.outputs.shared_services_cidr_blocks
  hcp_hvn_cidr_blocks = data.terraform_remote_state.shared_services.outputs.hcp_hvn_cidr_blocks
  accessible_cidr_blocks = {
    runtime_ec2_us_east_1 = "10.1.0.0/22"
    runtime_ec2_us_west_2 = "10.1.4.0/22"
    runtime_ec2_eu_west_1 = "10.1.8.0/22"
    runtime_ecs = "10.2.0.0/16"
    runtime_eks = "10.3.0.0/16"
    runtime_frontend = "10.4.0.0/16"
  }
}

module "us_east_1" {
  source = "./region"
  vpc_cidr_block = local.accessible_cidr_blocks.runtime_ec2_us_east_1
  region = local.us_east_1
  transit_gateway_id = local.transit_gateway_ids[local.us_east_1]
  shared_services_cidr_block = local.shared_services_cidr_blocks[local.us_east_1]
  hcp_hvn_cidr_block = local.hcp_hvn_cidr_blocks[local.us_east_1]

  # create routes to TGW for all CIDRs except own VPC
  accessible_cidr_blocks = [for cidr in values(local.accessible_cidr_blocks) : cidr if cidr != local.accessible_cidr_blocks.runtime_ec2_us_east_1]
}

module "us_west_2" {
  source = "./region"
  vpc_cidr_block = local.accessible_cidr_blocks.runtime_ec2_us_west_2
  region = local.us_west_2
  transit_gateway_id = local.transit_gateway_ids[local.us_west_2]
  shared_services_cidr_block = local.shared_services_cidr_blocks[local.us_west_2]
  hcp_hvn_cidr_block = local.hcp_hvn_cidr_blocks[local.us_west_2]

  # create routes to TGW for all CIDRs except own VPC
  accessible_cidr_blocks = [for cidr in values(local.accessible_cidr_blocks) : cidr if cidr != local.accessible_cidr_blocks.runtime_ec2_us_west_2]

  providers = {
    aws = aws.us_west_2
  }
}