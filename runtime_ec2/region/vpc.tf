# Network
module "network" {
  source = "../../modules/runtime_network"
  vpc_cidr_block = var.vpc_cidr_block
  region = var.region
  transit_gateway_id = var.transit_gateway_id
  shared_services_cidr_block = var.shared_services_cidr_block
  hcp_hvn_cidr_block = var.hcp_hvn_cidr_block
}
