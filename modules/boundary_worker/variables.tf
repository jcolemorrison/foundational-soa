variable "name" {
  type        = string
  description = "Name of keypair for Boundary worker"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for Boundary worker and security group"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to add to resources"
  default     = {}
}

locals {
  tags = merge({
    Purpose = "boundary"
    Module  = "foundational-soa//modules/boundary_worker"
  }, var.tags)
}
