variable "terraform_cloud_organization" {
  type        = string
  description = "Terraform Cloud organization that outputs HCP Consul address, token, and datacenter"
}

variable "domain_name" {
  type        = string
  description = "apex domain name of all services. i.e. hashidemo.com"
}

variable "aws_default_region" {
  type        = string
  description = "The default region that all resources will be deployed into."
  default     = "us-east-1"
}

variable "aws_default_tags" {
  type        = map(string)
  description = "Default tags added to all AWS resources."
  default = {
    Project = "foundational-soa-shared-services"
  }
}