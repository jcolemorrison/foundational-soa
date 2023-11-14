terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.23"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }
    boundary = {
      source  = "hashicorp/boundary"
      version = ">= 1.1"
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 3.22"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.76"
    }
  }
}