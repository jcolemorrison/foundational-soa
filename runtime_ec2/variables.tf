variable "aws_default_region" {
  type        = string
  description = "The default region that all resources will be deployed into."
  default     = "us-east-1"
}

variable "aws_default_tags" {
  type        = map(string)
  description = "Default tags added to all AWS resources."
  default = {
    Project = "foundational-soa-runtime-ec2"
  }
}

variable "terraform_cloud_organization" {
  type        = string
  description = "Terraform Cloud organization that outputs HCP Consul address, token, and datacenter"
}

locals {
  peers = {
    us_east_1 = "${local.name}-us-east-1-${local.runtime}"
    us_west_2 = "${local.name}-us-west-2-${local.runtime}"
    eu_west_1 = "${local.name}-eu-west-1-${local.runtime}"
  }
}
