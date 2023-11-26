locals {
  us_east_1                   = "us-east-1"
  us_west_2                   = "us-west-2"
  eu_west_1                   = "eu-west-1"
  transit_gateway_ids         = data.terraform_remote_state.shared_services.outputs.transit_gateway_ids
  shared_services_cidr_blocks = data.terraform_remote_state.shared_services.outputs.shared_services_cidr_blocks
  hcp_hvn_cidr_blocks         = data.terraform_remote_state.shared_services.outputs.hcp_hvn_cidr_blocks
  accessible_cidr_blocks      = data.terraform_remote_state.shared_services.outputs.accessible_cidr_blocks

  name    = "prod"
  runtime = "ec2"
}

module "us_east_1" {
  source                     = "./region"
  vpc_cidr_block             = local.accessible_cidr_blocks.runtime_ec2_us_east_1
  region                     = local.us_east_1
  transit_gateway_id         = local.transit_gateway_ids[local.us_east_1]
  shared_services_cidr_block = local.shared_services_cidr_blocks[local.us_east_1]
  hcp_hvn_cidr_block         = local.hcp_hvn_cidr_blocks[local.us_east_1]

  # create routes to TGW for all CIDRs except own VPC
  accessible_cidr_blocks = [for cidr in values(local.accessible_cidr_blocks) : cidr if cidr != local.accessible_cidr_blocks.runtime_ec2_us_east_1]

  name = local.name

  create_boundary_workers                  = true
  boundary_cluster_id                      = local.boundary_cluster_id
  boundary_worker_vault_path               = local.boundary_worker_vault_path
  boundary_worker_vault_token              = local.boundary_worker_vault_tokens.us_east_1
  boundary_worker_vault_namespace          = local.boundary_worker_vault_namespace
  boundary_worker_vault_namespace_absolute = local.boundary_worker_vault_namespace_absolute
  vault_address                            = local.vault_us_east_1.address

  boundary_project_scope_id = boundary_scope.runtime_ec2.id

  deploy_services          = false
  hcp_consul_cluster_id    = local.consul_us_east_1.id
  hcp_consul_cluster_token = local.consul_us_east_1.token

  peers_for_failover = values(local.peers)

  providers = {
    aws    = aws
    consul = consul.us_east_1
  }
}

module "us_west_2" {
  source                     = "./region"
  vpc_cidr_block             = local.accessible_cidr_blocks.runtime_ec2_us_west_2
  region                     = local.us_west_2
  transit_gateway_id         = local.transit_gateway_ids[local.us_west_2]
  shared_services_cidr_block = local.shared_services_cidr_blocks[local.us_west_2]
  hcp_hvn_cidr_block         = local.hcp_hvn_cidr_blocks[local.us_west_2]

  # create routes to TGW for all CIDRs except own VPC
  accessible_cidr_blocks = [for cidr in values(local.accessible_cidr_blocks) : cidr if cidr != local.accessible_cidr_blocks.runtime_ec2_us_west_2]

  name = local.name

  create_boundary_workers                  = true
  boundary_cluster_id                      = local.boundary_cluster_id
  boundary_worker_vault_path               = local.boundary_worker_vault_path
  boundary_worker_vault_token              = local.boundary_worker_vault_tokens.us_west_2
  boundary_worker_vault_namespace          = local.boundary_worker_vault_namespace
  boundary_worker_vault_namespace_absolute = local.boundary_worker_vault_namespace_absolute
  vault_address                            = local.vault_us_west_2.address

  boundary_project_scope_id = boundary_scope.runtime_ec2.id

  deploy_services          = false
  hcp_consul_cluster_id    = local.consul_us_west_2.id
  hcp_consul_cluster_token = local.consul_us_west_2.token

  peers_for_failover = values(local.peers)

  providers = {
    aws    = aws.us_west_2
    consul = consul.us_west_2
  }
}

module "eu_west_1" {
  source                     = "./region"
  vpc_cidr_block             = local.accessible_cidr_blocks.runtime_ec2_eu_west_1
  region                     = local.eu_west_1
  transit_gateway_id         = local.transit_gateway_ids[local.eu_west_1]
  shared_services_cidr_block = local.shared_services_cidr_blocks[local.eu_west_1]
  hcp_hvn_cidr_block         = local.hcp_hvn_cidr_blocks[local.eu_west_1]

  # create routes to TGW for all CIDRs except own VPC
  accessible_cidr_blocks = [for cidr in values(local.accessible_cidr_blocks) : cidr if cidr != local.accessible_cidr_blocks.runtime_ec2_eu_west_1]

  name = local.name

  create_boundary_workers                  = true
  boundary_cluster_id                      = local.boundary_cluster_id
  boundary_worker_vault_path               = local.boundary_worker_vault_path
  boundary_worker_vault_token              = local.boundary_worker_vault_tokens.us_west_2
  boundary_worker_vault_namespace          = local.boundary_worker_vault_namespace
  boundary_worker_vault_namespace_absolute = local.boundary_worker_vault_namespace_absolute
  vault_address                            = local.vault_eu_west_1.address

  boundary_project_scope_id = boundary_scope.runtime_ec2.id

  deploy_services          = false
  hcp_consul_cluster_id    = local.consul_eu_west_1.id
  hcp_consul_cluster_token = local.consul_eu_west_1.token

  peers_for_failover = values(local.peers)

  providers = {
    aws    = aws.eu_west_1
    consul = consul.eu_west_1
  }
}
