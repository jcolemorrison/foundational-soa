variable "name" {
  type        = string
  description = "Name of keypair for Boundary worker"
}

variable "region" {
  type        = string
  description = "Region for Boundary worker, used for filtering"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for Boundary worker and security group"
}

variable "public_subnet_id" {
  type        = string
  description = "Public subnet ID for Boundary worker"
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

variable "vault" {
  type = object({
    address   = string
    namespace = string
    path      = string
    token     = string
  })
  description = "Vault attributes to store Boundary worker PKI key"
  sensitive   = true
}

variable "boundary_cluster_id" {
  type        = string
  description = "Boundary cluster ID"
}

variable "worker_upstreams" {
  description = "A list of workers to connect to upstream. For multi-hop worker sessions. Format should be [\"<upstream_worker_public_addr>:9202\"]"
  type        = list(string)
  default     = []
}

variable "worker_tags" {
  description = "Additional list of worker tags for filtering in Boundary"
  type        = list(string)
  default     = []
}

variable "keypair_name" {
  description = "Name of AWS keypair for Boundary worker"
  type        = string
}