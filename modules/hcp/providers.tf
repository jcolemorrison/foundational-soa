terraform {
  required_version = ">=1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.22"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = ">= 0.75"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5"
    }
  }
}