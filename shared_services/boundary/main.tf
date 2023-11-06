terraform {
  required_providers {
    vault = {
      source  = "hashicorp/boundary"
      version = "~> 1.1.10"
    }
  }
}

provider "boundary" {
  addr                      = data.terraform_remote_state.shared_services.outputs.hcp_us_east_1.boundary.address
  auth_method_login_name    = data.terraform_remote_state.shared_services.outputs.hcp_us_east_1.boundary.username
  auth_method_password = data.terraform_remote_state.shared_services.outputs.hcp_us_east_1.boundary.password
}
