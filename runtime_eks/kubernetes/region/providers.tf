terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.23"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.13"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.7"
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 3.22"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = ">= 0.76"
    }
  }
}
