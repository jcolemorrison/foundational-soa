terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.22"
    }
  }
}

provider "vault" {
  address   = data.terraform_remote_state.shared_services.outputs.hcp_us_east_1.vault.address
  namespace = data.terraform_remote_state.shared_services.outputs.hcp_us_east_1.vault.namespace
  token     = data.terraform_remote_state.shared_services.outputs.hcp_us_east_1.vault.token
}

provider "vault" {
  alias     = "us_west_2"
  address   = data.terraform_remote_state.shared_services.outputs.hcp_us_west_2.vault.address
  namespace = data.terraform_remote_state.shared_services.outputs.hcp_us_west_2.vault.namespace
  token     = data.terraform_remote_state.shared_services.outputs.hcp_us_west_2.vault.token
}

provider "vault" {
  alias     = "eu_west_1"
  address   = data.terraform_remote_state.shared_services.outputs.hcp_eu_west_1.vault.address
  namespace = data.terraform_remote_state.shared_services.outputs.hcp_eu_west_1.vault.namespace
  token     = data.terraform_remote_state.shared_services.outputs.hcp_eu_west_1.vault.token
}
