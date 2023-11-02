variable "aws_default_region" {
  type        = string
  description = "The default region that all resources will be deployed into."
  default     = "us-east-1"
}

variable "aws_default_tags" {
  type        = map(string)
  description = "Default tags added to all AWS resources."
  default = {
    Project = "foundational-soa-runtime-eks"
  }
}

variable "terraform_cloud_organization" {
  type        = string
  description = "Terraform Cloud organization that outputs HCP Consul address, token, and datacenter"
}

variable "keypair_us_east_1" {
  type        = string
  description = "Keypair for us-east-1"
}