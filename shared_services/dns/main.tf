terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.23.1"
    }
  }
}

provider "aws" {
  region = local.aws_default_region
  default_tags {
    tags = local.aws_default_tags
  }
}