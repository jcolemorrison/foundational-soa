variable "vpc_cidr_block" {
  type        = string
  description = "Cidr block for the VPC.  Using a /22 Subnet Mask for this project is recommended."
}

variable "region" {
  type = string
  description = "AWS region to deploy the transit gateway to.  Only used for naming purposes."
}

variable "tgw_asn" {
  type = number
  description = "Unique identifier for this autonomous system (network) on AWS side. Should be between 64512 and 65535."
}

variable "tgw_cidr_block" {
  type        = string
  description = "Cidr block for the Transit Gateway.  Using a /22 Subnet Mask for this project is recommended."
}

variable "tags" {
  type        = map(string)
  description = "Common tags for AWS resources"
  default     = {}
}

variable "organization_arn" {
  type = string
  description = "ARN of the AWS organization this account belongs to."
}

variable "external_principals" {
  type = list(string)
  description = "List of external principals to share transit gateway with."
  default = []
}