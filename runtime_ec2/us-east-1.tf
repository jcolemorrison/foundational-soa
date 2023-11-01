locals {
  us_east_1 = "us-east-1"
  transit_gateway_ids = data.terraform_remote_state.shared_services.transit_gateway_ids
  shared_services_cidr_blocks = data.terraform_remote_state.shared_services.shared_services_cidr_blocks
  hcp_hvn_cidr_blocks = data.terraform_remote_state.shared_services.hcp_hvn_cidr_blocks
}

module "us_east_1" {
  source = "./region"
  vpc_cidr_block = "10.1.0.0/22"
  region = local.us_east_1
  transit_gateway_id = local.transit_gateway_ids[local.us_east_1]
  shared_services_cidr_block = local.shared_services_cidr_blocks[local.us_east_1]
  hcp_hvn_cidr_block = local.hcp_hvn_cidr_blocks[local.us_east_1]
}