output "default_region" {
  value       = data.aws_region.current
  description = "default region of deployment in AWS"
}

output "default_tags" {
  value       = var.aws_default_tags
  description = "default tags for AWS resources"
}

output "hcp_us_east_1" {
  value = {
    boundary = module.hcp_us_east_1.hcp_boundary
    vault    = module.hcp_us_east_1.hcp_vault
    consul   = module.hcp_us_east_1.hcp_consul
  }
  sensitive   = true
  description = "HCP Consul, Vault, and Boundary attributes for us-east-1"
}

output "hcp_us_west_2" {
  value = {
    boundary = module.hcp_us_west_2.hcp_boundary
    vault    = module.hcp_us_west_2.hcp_vault
    consul   = module.hcp_us_west_2.hcp_consul
  }
  sensitive   = true
  description = "HCP Consul and Vault attributes for us-west-2"
}

output "hcp_eu_west_1" {
  value = {
    boundary = module.hcp_eu_west_1.hcp_boundary
    vault    = module.hcp_eu_west_1.hcp_vault
    consul   = module.hcp_eu_west_1.hcp_consul
  }
  sensitive   = true
  description = "HCP Consul and Vault attributes for eu-west-1"
}

output "transit_gateway_ids" {
  value = {
    "us-east-1" = module.network_us_east_1.transit_gateway_id
    "us-west-2" = module.network_us_west_2.transit_gateway_id
    "eu-west-1" = module.network_eu_west_1.transit_gateway_id
  }
  description = "Transit gateways for the various regions"
}

output "shared_services_cidr_blocks" {
  value = {
    "us-east-1" = module.network_us_east_1.vpc_cidr_block
    "us-west-2" = module.network_us_west_2.vpc_cidr_block
    "eu-west-1" = module.network_eu_west_1.vpc_cidr_block
  }
  description = "Shared Services of VPC CIDRs for the various regions"
}

output "hcp_hvn_cidr_blocks" {
  value = {
    "us-east-1" = module.hcp_us_east_1.hvn_cidr_block
    "us-west-2" = module.hcp_us_west_2.hvn_cidr_block
    "eu-west-1" = module.hcp_eu_west_1.hvn_cidr_block
  }
  description = "HCP HVN CIDRs for the various regions"
}

output "accessible_cidr_blocks" {
  value = {
    runtime_ec2           = local.runtime_ec2
    runtime_ecs           = local.runtime_ecs
    runtime_eks_us_east_1 = local.runtime_eks_us_east_1
    runtime_eks_us_west_2 = local.runtime_eks_us_west_2
    runtime_eks_eu_west_1 = local.runtime_eks_eu_west_1
    runtime_frontend      = local.runtime_frontend
  }
}