# Note: filter out wavelength zones if they're enabled in the account being deployed to.
data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "group-name"
    values = [var.aws_default_region]
  }
}

# Current region being deployed into
data "aws_region" "current" {}

# Current AWS Account being deployed into
data "aws_caller_identity" "current" {}

data "terraform_remote_state" "shared_services" {
  backend = "remote"

  config = {
    organization = var.terraform_cloud_organization
    workspaces = {
      name = "shared-services"
    }
  }
}

data "terraform_remote_state" "shared_services_vault" {
  backend = "remote"

  config = {
    organization = var.terraform_cloud_organization
    workspaces = {
      name = "shared-services-vault"
    }
  }
}

data "terraform_remote_state" "shared_services_boundary" {
  backend = "remote"

  config = {
    organization = var.terraform_cloud_organization
    workspaces = {
      name = "shared-services-boundary"
    }
  }
}

data "terraform_remote_state" "runtime_eks_applications" {
  backend = "remote"

  config = {
    organization = var.terraform_cloud_organization
    workspaces = {
      name = "runtime-eks-applications"
    }
  }
}

locals {
  boundary_cluster_id             = split(".", replace(data.terraform_remote_state.shared_services.outputs.hcp_us_east_1.boundary.address, "https://", "", ))[0]
  vault_us_east_1                 = data.terraform_remote_state.shared_services.outputs.hcp_us_east_1.vault
  vault_us_west_2                 = data.terraform_remote_state.shared_services.outputs.hcp_us_west_2.vault
  vault_eu_west_1                 = data.terraform_remote_state.shared_services.outputs.hcp_eu_west_1.vault
  boundary_worker_vault_namespace = data.terraform_remote_state.shared_services_vault.outputs.boundary_worker_namespace
  boundary_worker_vault_path      = data.terraform_remote_state.shared_services_vault.outputs.boundary_worker_path
  boundary_worker_vault_tokens    = data.terraform_remote_state.shared_services_vault.outputs.boundary_worker_token
  boundary_org_scope_id           = data.terraform_remote_state.shared_services_boundary.outputs.org_scope_id
  consul_us_east_1                = data.terraform_remote_state.shared_services.outputs.hcp_us_east_1.consul
  consul_us_west_2                = data.terraform_remote_state.shared_services.outputs.hcp_us_west_2.consul
  consul_eu_west_1                = data.terraform_remote_state.shared_services.outputs.hcp_eu_west_1.consul
  consul_ca_us_east_1             = data.terraform_remote_state.shared_services_vault.outputs.consul_ca.us_east_1
  consul_ca_us_west_2             = data.terraform_remote_state.shared_services_vault.outputs.consul_ca.us_west_2
  consul_ca_eu_west_1             = data.terraform_remote_state.shared_services_vault.outputs.consul_ca.eu_west_1
}