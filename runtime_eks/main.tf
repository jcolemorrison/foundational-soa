locals {
  us_east_1 = "us-east-1"
  us_west_2 = "us-west-2"
  eu_west_1 = "eu-west-1"

  transit_gateway_ids         = data.terraform_remote_state.shared_services.outputs.transit_gateway_ids
  shared_services_cidr_blocks = data.terraform_remote_state.shared_services.outputs.shared_services_cidr_blocks
  hcp_hvn_cidr_blocks         = data.terraform_remote_state.shared_services.outputs.hcp_hvn_cidr_blocks
  accessible_cidr_blocks      = data.terraform_remote_state.shared_services.outputs.accessible_cidr_blocks

  name    = "prod"
  db_name = "customers"
}

resource "aws_rds_global_cluster" "database" {
  global_cluster_identifier = local.name
  engine                    = "aurora-postgresql"
  database_name             = local.db_name
  force_destroy             = true
  storage_encrypted         = false
}

module "us_east_1" {
  source                     = "./region"
  vpc_cidr_block             = local.accessible_cidr_blocks.runtime_eks_us_east_1
  region                     = local.us_east_1
  transit_gateway_id         = local.transit_gateway_ids[local.us_east_1]
  shared_services_cidr_block = local.shared_services_cidr_blocks[local.us_east_1]
  hcp_hvn_cidr_block         = local.hcp_hvn_cidr_blocks[local.us_east_1]

  # create routes to TGW for all CIDRs except own VPC
  accessible_cidr_blocks = [for cidr in values(local.accessible_cidr_blocks) : cidr if cidr != local.accessible_cidr_blocks.runtime_eks_us_east_1]

  name = local.name

  create_boundary_workers     = true
  boundary_cluster_id         = local.boundary_cluster_id
  boundary_worker_vault_path  = local.boundary_worker_vault_path
  boundary_worker_vault_token = local.boundary_worker_vault_tokens.us_east_1
  vault_address               = local.vault_us_east_1.address
  vault_namespace             = local.boundary_worker_vault_namespace

  create_eks_cluster = true

  boundary_project_scope_id = boundary_scope.runtime_eks.id

  create_database         = true
  is_database_primary     = true
  global_cluster_id       = aws_rds_global_cluster.database.id
  database_engine         = aws_rds_global_cluster.database.engine
  database_engine_version = aws_rds_global_cluster.database.engine_version
  db_name                 = local.db_name

  providers = {
    aws    = aws
    consul = consul.us_east_1
  }
}

module "us_west_2" {
  source                     = "./region"
  vpc_cidr_block             = local.accessible_cidr_blocks.runtime_eks_us_west_2
  region                     = local.us_west_2
  transit_gateway_id         = local.transit_gateway_ids[local.us_west_2]
  shared_services_cidr_block = local.shared_services_cidr_blocks[local.us_west_2]
  hcp_hvn_cidr_block         = local.hcp_hvn_cidr_blocks[local.us_west_2]

  # create routes to TGW for all CIDRs except own VPC
  accessible_cidr_blocks = [for cidr in values(local.accessible_cidr_blocks) : cidr if cidr != local.accessible_cidr_blocks.runtime_eks_us_west_2]

  name = local.name

  create_boundary_workers     = true
  boundary_cluster_id         = local.boundary_cluster_id
  boundary_worker_vault_path  = local.boundary_worker_vault_path
  boundary_worker_vault_token = local.boundary_worker_vault_tokens.us_west_2
  vault_address               = local.vault_us_west_2.address
  vault_namespace             = local.boundary_worker_vault_namespace

  create_eks_cluster = true

  boundary_project_scope_id = boundary_scope.runtime_eks.id

  create_database         = true # NOTE: set us-east-1 to true FIRST to set database primary
  is_database_primary     = false
  global_cluster_id       = aws_rds_global_cluster.database.id
  database_engine         = aws_rds_global_cluster.database.engine
  database_engine_version = aws_rds_global_cluster.database.engine_version
  db_name                 = local.db_name

  providers = {
    aws    = aws.us_west_2
    consul = consul.us_west_2
  }
}

module "eu_west_1" {
  source                     = "./region"
  vpc_cidr_block             = local.accessible_cidr_blocks.runtime_eks_eu_west_1
  region                     = local.eu_west_1
  transit_gateway_id         = local.transit_gateway_ids[local.eu_west_1]
  shared_services_cidr_block = local.shared_services_cidr_blocks[local.eu_west_1]
  hcp_hvn_cidr_block         = local.hcp_hvn_cidr_blocks[local.eu_west_1]

  # create routes to TGW for all CIDRs except own VPC
  accessible_cidr_blocks = [for cidr in values(local.accessible_cidr_blocks) : cidr if cidr != local.accessible_cidr_blocks.runtime_eks_eu_west_1]

  name = local.name

  create_boundary_workers     = true
  boundary_cluster_id         = local.boundary_cluster_id
  boundary_worker_vault_path  = local.boundary_worker_vault_path
  boundary_worker_vault_token = local.boundary_worker_vault_tokens.eu_west_1
  vault_address               = local.vault_eu_west_1.address
  vault_namespace             = local.boundary_worker_vault_namespace

  create_eks_cluster = true

  boundary_project_scope_id = boundary_scope.runtime_eks.id

  create_database         = true # NOTE: set us-east-1 to true FIRST to set database primary
  is_database_primary     = false
  global_cluster_id       = aws_rds_global_cluster.database.id
  database_engine         = aws_rds_global_cluster.database.engine
  database_engine_version = aws_rds_global_cluster.database.engine_version
  db_name                 = local.db_name

  providers = {
    aws    = aws.eu_west_1
    consul = consul.eu_west_1
  }
}
