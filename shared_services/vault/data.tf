data "terraform_remote_state" "shared_services" {
  backend = "remote"

  config = {
    organization = var.terraform_cloud_organization
    workspaces = {
      name = "shared-services"
    }
  }
}

locals {
  aws_default_region = data.terraform_remote_state.shared_services.outputs.default_region.id
  aws_default_tags   = data.terraform_remote_state.shared_services.outputs.default_tags
}

data "aws_partition" "current" {}