terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.23.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    boundary = {
      source  = "hashicorp/boundary"
      version = "~> 1.1.10"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.22"
    }
  }
}

provider "aws" {
  region = var.aws_default_region
  default_tags {
    tags = var.aws_default_tags
  }
}

provider "aws" {
  region = "us-west-2"
  alias  = "us_west_2"
  default_tags {
    tags = var.aws_default_tags
  }
}

provider "aws" {
  region = "eu-west-1"
  alias  = "eu_west_1"
  default_tags {
    tags = var.aws_default_tags
  }
}

provider "boundary" {
  addr                   = data.terraform_remote_state.shared_services.outputs.hcp_us_east_1.boundary.address
  auth_method_login_name = data.terraform_remote_state.shared_services.outputs.hcp_us_east_1.boundary.username
  auth_method_password   = data.terraform_remote_state.shared_services.outputs.hcp_us_east_1.boundary.password
}

provider "vault" {
  address   = data.terraform_remote_state.shared_services.outputs.hcp_us_east_1.vault.address
  namespace = local.boundary_worker_vault_namespace
  token     = data.terraform_remote_state.shared_services.outputs.hcp_us_east_1.vault.token
}

provider "vault" {
  address   = data.terraform_remote_state.shared_services.outputs.hcp_us_east_1.vault.address
  namespace = data.terraform_remote_state.shared_services.outputs.hcp_us_east_1.vault.namespace
  token     = data.terraform_remote_state.shared_services.outputs.hcp_us_east_1.vault.token

  alias = "admin"
}
