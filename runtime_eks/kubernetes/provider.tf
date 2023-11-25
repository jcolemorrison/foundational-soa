terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.23"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.13"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.7"
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
  region = local.aws_default_region
}

provider "aws" {
  region = "us-west-2"
  alias  = "us_west_2"
}

provider "aws" {
  region = "eu-west-1"
  alias  = "eu_west_1"
}

provider "kubernetes" {
  alias                  = "us_east_1"
  host                   = data.aws_eks_cluster.us_east_1.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.us_east_1.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.us_east_1.token
}

provider "kubernetes" {
  alias                  = "us_west_2"
  host                   = data.aws_eks_cluster.us_west_2.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.us_west_2.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.us_west_2.token
}

provider "kubernetes" {
  alias                  = "eu_west_1"
  host                   = data.aws_eks_cluster.eu_west_1.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eu_west_1.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eu_west_1.token
}

provider "helm" {
  alias = "us_east_1"
  kubernetes {
    host                   = data.aws_eks_cluster.us_east_1.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.us_east_1.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.us_east_1.token
  }
}

provider "helm" {
  alias = "us_west_2"
  kubernetes {
    host                   = data.aws_eks_cluster.us_west_2.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.us_west_2.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.us_west_2.token
  }
}

provider "helm" {
  alias = "eu_west_1"
  kubernetes {
    host                   = data.aws_eks_cluster.eu_west_1.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eu_west_1.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.eu_west_1.token
  }
}

provider "vault" {
  alias     = "us_east_1"
  address   = local.us_east_1.vault.address
  token     = local.us_east_1.vault.token
  namespace = local.vault_database.namespace
}

provider "vault" {
  alias     = "us_west_2"
  address   = local.us_west_2.vault.address
  token     = local.us_west_2.vault.token
  namespace = local.vault_database.namespace
}

provider "vault" {
  alias     = "eu_west_1"
  address   = local.eu_west_1.vault.address
  token     = local.eu_west_1.vault.token
  namespace = local.vault_database.namespace
}