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

locals {
  consul_ca_token = data.terraform_remote_state.shared_services_vault.outputs.consul_ca_token
  vault = {
    "us_east_1" = data.terraform_remote_state.shared_services.outputs.hcp_us_east_1.vault
    "us_west_2" = data.terraform_remote_state.shared_services.outputs.hcp_us_west_2.vault
    "eu_west_1" = data.terraform_remote_state.shared_services.outputs.hcp_eu_west_1.vault
  }
  consul_ca = data.terraform_remote_state.shared_services_vault.outputs.consul_ca
}