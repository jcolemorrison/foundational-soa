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

variable "keypair_us_east_1" {
  type        = string
  description = "ec2 keypair for bastion testing (us-east-1)"
  default     = null
}

variable "keypair_us_west_2" {
  type        = string
  description = "ec2 keypair for bastion testing (us-west-2)"
  default     = null
}

variable "keypair_eu_west_1" {
  type        = string
  description = "ec2 keypair for bastion testing (eu-west-1)"
  default     = null
}

resource "random_pet" "prefix" {
  length = 1
}

locals {
  prefix = random_pet.prefix.id
}