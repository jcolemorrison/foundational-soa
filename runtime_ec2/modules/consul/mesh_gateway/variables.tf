variable "name" {
  type        = string
  description = "Name used for mesh gateway VM"
  default     = "mesh-gateway"
}

variable "fake_service_name" {
  type        = string
  description = "Name to pass to fake-service"
  default     = null
}

variable "instance_type" {
  type        = string
  description = "Instance type"
  default     = "t2.small"
}

variable "vpc_id" {
  type        = string
  description = "ID of VPC for instance"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for VPC"
}

variable "hcp_consul_cluster_id" {
  type        = string
  description = "HCP Consul cluster ID"
}

variable "hcp_consul_cluster_token" {
  type        = string
  description = "Consul bootstrap token for clients to start"
  sensitive   = true
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs for mesh gateway load balancer"
}

variable "subnet_id" {
  type        = string
  description = "ID of subnet to create instance"
}

variable "key_pair_name" {
  type        = string
  description = "Name of key pair attached to Boundary worker to add to application on VM"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security groups to attach to instance"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to include with resources"
  default     = {}
}

locals {
  tags = merge(
    {
      Module = "foundational-soa//runtime_ec2/modules/consul/mesh_gateway",
      Name   = var.name
      Consul = "client"
    },
  var.tags)
}
