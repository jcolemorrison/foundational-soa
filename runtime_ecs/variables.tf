variable "aws_default_region" {
  type        = string
  description = "The default region that all resources will be deployed into."
  default     = "us-east-1"
}

variable "aws_default_tags" {
  type        = map(string)
  description = "Default tags added to all AWS resources."
  default = {
    Project = "foundational-soa-runtime-ecs"
  }
}

variable "terraform_cloud_organization" {
  type        = string
  description = "Terraform Cloud organization that outputs HCP Consul address, token, and datacenter"
}

## Route53

variable "public_domain_name" {
  type = string
  description = "Domain name for overall architecture.  Should have a hosted zone created in AWS Route53.  Registering domain in Route53 results in a zone being created by default. i.e. 'hashidemo.com'"
}

variable "public_subdomain_name" {
  type = string
  description = "Sub domain name for this runtime.  i.e. 'ecs' which would result in a subdomain of 'ecs.hashidemo.com'"
}
