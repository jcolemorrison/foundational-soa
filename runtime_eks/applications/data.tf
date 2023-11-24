data "terraform_remote_state" "shared_services" {
  backend = "remote"

  config = {
    organization = var.terraform_cloud_organization
    workspaces = {
      name = "shared-services"
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

data "terraform_remote_state" "runtime_eks_kubernetes" {
  backend = "remote"

  config = {
    organization = var.terraform_cloud_organization
    workspaces = {
      name = "runtime-eks-kubernetes"
    }
  }
}

locals {
  aws_default_region = data.terraform_remote_state.runtime_eks.outputs.default_region.id
  cluster_name       = data.terraform_remote_state.runtime_eks.outputs.cluster_name
  us_east_1          = data.terraform_remote_state.shared_services.outputs.hcp_us_east_1
  us_west_2          = data.terraform_remote_state.shared_services.outputs.hcp_us_west_2
  eu_west_1          = data.terraform_remote_state.shared_services.outputs.hcp_eu_west_1

  aws_irsa = data.terraform_remote_state.runtime_eks.outputs.irsa

  vault_database = data.terraform_remote_state.runtime_eks.outputs.vault_database
  service_name   = data.terraform_remote_state.runtime_eks.outputs.cluster_name

  vault_kubernetes_auth_path = data.terraform_remote_state.runtime_eks_kubernetes.outputs.kubernetes_auth_path
}

data "aws_eks_cluster" "us_east_1" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "us_east_1" {
  name = local.cluster_name
}

data "aws_eks_cluster" "us_west_2" {
  name = local.cluster_name

  provider = aws.us_west_2
}

data "aws_eks_cluster_auth" "us_west_2" {
  name = local.cluster_name

  provider = aws.us_west_2
}

data "aws_eks_cluster" "eu_west_1" {
  name = local.cluster_name

  provider = aws.eu_west_1
}

data "aws_eks_cluster_auth" "eu_west_1" {
  name = local.cluster_name

  provider = aws.eu_west_1
}
