terraform {
  required_providers {
    consul = {
      source  = "hashicorp/consul"
      version = "~> 2.19"
    }
  }
}

provider "consul" {
  alias      = "us_east_1"
  address    = data.terraform_remote_state.shared_services.outputs.hcp_us_east_1.consul.address
  token      = data.terraform_remote_state.shared_services.outputs.hcp_us_east_1.consul.token
  datacenter = data.terraform_remote_state.shared_services.outputs.hcp_us_east_1.consul.datacenter
}

provider "consul" {
  alias      = "us_west_2"
  address    = data.terraform_remote_state.shared_services.outputs.hcp_us_west_2.consul.address
  token      = data.terraform_remote_state.shared_services.outputs.hcp_us_west_2.consul.token
  datacenter = data.terraform_remote_state.shared_services.outputs.hcp_us_west_2.consul.datacenter
}

provider "consul" {
  alias      = "eu_west_1"
  address    = data.terraform_remote_state.shared_services.outputs.hcp_eu_west_1.consul.address
  token      = data.terraform_remote_state.shared_services.outputs.hcp_eu_west_1.consul.token
  datacenter = data.terraform_remote_state.shared_services.outputs.hcp_eu_west_1.consul.datacenter
}