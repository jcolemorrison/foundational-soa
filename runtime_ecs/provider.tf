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
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.76"
    }
  }
}

provider "hcp" {}

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

# provider "vault" {
#   alias = "consul"
#   address   = data.terraform_remote_state.shared_services.outputs.hcp_us_east_1.vault.address
#   namespace = local.consul_ca_us_east_1.namespace # admin/consul/ for all regions
#   token     = data.terraform_remote_state.shared_services.outputs.hcp_us_east_1.vault.token
# }