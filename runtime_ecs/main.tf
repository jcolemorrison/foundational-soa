locals {
  us_east_1                   = "us-east-1"
  us_west_2                   = "us-west-2"
  eu_west_1                   = "eu-west-1"
  transit_gateway_ids         = data.terraform_remote_state.shared_services.outputs.transit_gateway_ids
  shared_services_cidr_blocks = data.terraform_remote_state.shared_services.outputs.shared_services_cidr_blocks
  hcp_hvn_cidr_blocks         = data.terraform_remote_state.shared_services.outputs.hcp_hvn_cidr_blocks
  accessible_cidr_blocks      = data.terraform_remote_state.shared_services.outputs.accessible_cidr_blocks

  name = "prod"
}

module "us_east_1" {
  source                     = "./region"
  vpc_cidr_block             = local.accessible_cidr_blocks.runtime_ecs_us_east_1
  region                     = local.us_east_1
  transit_gateway_id         = local.transit_gateway_ids[local.us_east_1]
  shared_services_cidr_block = local.shared_services_cidr_blocks[local.us_east_1]
  hcp_hvn_cidr_block         = local.hcp_hvn_cidr_blocks[local.us_east_1]

  # create routes to TGW for all CIDRs except own VPC
  accessible_cidr_blocks = [for cidr in values(local.accessible_cidr_blocks) : cidr if cidr != local.accessible_cidr_blocks.runtime_ecs_us_east_1]
  public_domain_name = var.public_domain_name
  public_subdomain_name = var.public_subdomain_name
  subdomain_zone_id = aws_route53_zone.subdomain.zone_id

  container_instance_profile = aws_iam_instance_profile.container_instance_profile.arn
  execute_command_policy = aws_iam_policy.execute_command.arn
  ecs_service_role = aws_iam_role.ecs_service.arn

  name = local.name

  create_boundary_workers     = true
  boundary_cluster_id         = local.boundary_cluster_id
  boundary_worker_vault_path  = local.boundary_worker_vault_path
  boundary_worker_vault_token = local.boundary_worker_vault_tokens.us_east_1
  vault_address               = local.vault_us_east_1.address
  vault_namespace             = local.boundary_worker_vault_namespace

  boundary_project_scope_id = boundary_scope.runtime_ecs.id

  consul_bootstrap_token = local.consul_us_east_1.token
  consul_server_hosts = local.consul_us_east_1.retry_join
  consul_admin_partition = "ecs"
  consul_cluster_id = local.consul_us_east_1.id

  test_bastion_enabled = true
  test_bastion_keypair = var.test_bastion_keypair_us_east_1
  test_bastion_cidr_blocks = [
    local.accessible_cidr_blocks.runtime_ecs_us_east_1,
    local.accessible_cidr_blocks.runtime_ecs_us_west_2,
    local.accessible_cidr_blocks.runtime_ecs_eu_west_1
  ]
}

module "us_west_2" {
  source                     = "./region"
  vpc_cidr_block             = local.accessible_cidr_blocks.runtime_ecs_us_west_2
  region                     = local.us_west_2
  transit_gateway_id         = local.transit_gateway_ids[local.us_west_2]
  shared_services_cidr_block = local.shared_services_cidr_blocks[local.us_west_2]
  hcp_hvn_cidr_block         = local.hcp_hvn_cidr_blocks[local.us_west_2]

  # create routes to TGW for all CIDRs except own VPC
  accessible_cidr_blocks = [for cidr in values(local.accessible_cidr_blocks) : cidr if cidr != local.accessible_cidr_blocks.runtime_ecs_us_west_2]
  public_domain_name = var.public_domain_name
  public_subdomain_name = var.public_subdomain_name
  subdomain_zone_id = aws_route53_zone.subdomain.zone_id

  container_instance_profile = aws_iam_instance_profile.container_instance_profile.arn
  execute_command_policy = aws_iam_policy.execute_command.arn
  ecs_service_role = aws_iam_role.ecs_service.arn

  name = local.name

  create_boundary_workers     = true
  boundary_cluster_id         = local.boundary_cluster_id
  boundary_worker_vault_path  = local.boundary_worker_vault_path
  boundary_worker_vault_token = local.boundary_worker_vault_tokens.us_west_2
  vault_address               = local.vault_us_west_2.address
  vault_namespace             = local.boundary_worker_vault_namespace

  boundary_project_scope_id = boundary_scope.runtime_ecs.id

  consul_bootstrap_token = local.consul_us_west_2.token
  consul_server_hosts = local.consul_us_west_2.retry_join
  consul_admin_partition = "ecs"
  consul_cluster_id = local.consul_us_west_2.id

  test_bastion_enabled = true
  test_bastion_keypair = var.test_bastion_keypair_us_west_2
  test_bastion_cidr_blocks = [
    local.accessible_cidr_blocks.runtime_ecs_us_east_1,
    local.accessible_cidr_blocks.runtime_ecs_us_west_2,
    local.accessible_cidr_blocks.runtime_ecs_eu_west_1
  ]

  providers = {
    aws = aws.us_west_2
  }
}

module "eu_west_1" {
  source                     = "./region"
  vpc_cidr_block             = local.accessible_cidr_blocks.runtime_ecs_eu_west_1
  region                     = local.eu_west_1
  transit_gateway_id         = local.transit_gateway_ids[local.eu_west_1]
  shared_services_cidr_block = local.shared_services_cidr_blocks[local.eu_west_1]
  hcp_hvn_cidr_block         = local.hcp_hvn_cidr_blocks[local.eu_west_1]

  # create routes to TGW for all CIDRs except own VPC
  accessible_cidr_blocks = [for cidr in values(local.accessible_cidr_blocks) : cidr if cidr != local.accessible_cidr_blocks.runtime_ecs_eu_west_1]
  public_domain_name = var.public_domain_name
  public_subdomain_name = var.public_subdomain_name
  subdomain_zone_id = aws_route53_zone.subdomain.zone_id

  container_instance_profile = aws_iam_instance_profile.container_instance_profile.arn
  execute_command_policy = aws_iam_policy.execute_command.arn
  ecs_service_role = aws_iam_role.ecs_service.arn

  name = local.name

  create_boundary_workers     = true
  boundary_cluster_id         = local.boundary_cluster_id
  boundary_worker_vault_path  = local.boundary_worker_vault_path
  boundary_worker_vault_token = local.boundary_worker_vault_tokens.eu_west_1
  vault_address               = local.vault_eu_west_1.address
  vault_namespace             = local.boundary_worker_vault_namespace

  boundary_project_scope_id = boundary_scope.runtime_ecs.id

  consul_bootstrap_token = local.consul_eu_west_1.token
  consul_server_hosts = local.consul_eu_west_1.retry_join
  consul_admin_partition = "ecs"
  consul_cluster_id = local.consul_eu_west_1.id

  test_bastion_enabled = true
  test_bastion_keypair = var.test_bastion_keypair_eu_west_1
  test_bastion_cidr_blocks = [
    local.accessible_cidr_blocks.runtime_ecs_us_east_1,
    local.accessible_cidr_blocks.runtime_ecs_us_west_2,
    local.accessible_cidr_blocks.runtime_ecs_eu_west_1
  ]

  providers = {
    aws = aws.eu_west_1
  }
}