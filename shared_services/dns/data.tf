data "terraform_remote_state" "shared_services" {
  backend = "remote"

  config = {
    organization = var.terraform_cloud_organization
    workspaces = {
      name = "shared-services"
    }
  }
}

data "terraform_remote_state" "runtime_ecs" {
  backend = "remote"

  config = {
    organization = var.terraform_cloud_organization
    workspaces = {
      name = "runtime-ecs"
    }
  }
}

data "terraform_remote_state" "runtime_frontend" {
  backend = "remote"

  config = {
    organization = var.terraform_cloud_organization
    workspaces = {
      name = "runtime-frontend"
    }
  }
}

data "terraform_remote_state" "runtime_eks" {
  backend = "remote"

  config = {
    organization = var.terraform_cloud_organization
    workspaces = {
      name = "runtime-eks"
    }
  }
}


locals {
  aws_default_region = data.terraform_remote_state.shared_services.outputs.default_region.id
  aws_default_tags   = data.terraform_remote_state.shared_services.outputs.default_tags
}