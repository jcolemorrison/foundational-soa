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

variable "runtime_ecs_subdomain_name_servers" {
  type        = list(string)
  description = "List of name servers for the ECS subdomain."
  default = null
}

variable "runtime_frontend_subdomain_name_servers" {
  type        = list(string)
  description = "List of name servers for the frontend subdomain."
  default = null
}

variable "runtime_eks_subdomain_name_servers" {
  type        = list(string)
  description = "List of name servers for the EKS subdomain."
  default = null
}