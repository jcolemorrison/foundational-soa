terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.23"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = ">= 0.76"
    }
  }
}