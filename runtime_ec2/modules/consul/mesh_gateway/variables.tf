variable "name" {
  type        = string
  description = "Name used for VMs and other resources"
}

variable "is_mesh_gateway" {
  type        = bool
  description = "Deploy instance as Consul mesh gateway"
  default     = false
}

variable "fake_service_name" {
  type        = string
  description = "Name to pass to fake-service"
  default     = null
}

variable "fake_service_message" {
  type        = string
  description = "Message to pass to fake-service"
  default     = null
}

variable "fake_service_port" {
  type        = string
  description = "Message to pass to fake-service"
  default     = 9090
}

variable "upstream_service_name" {
  type        = number
  description = "Upstream service name"
  default     = null
}

variable "upstream_service_local_bind_port" {
  type        = number
  description = "Local port to bind to access upstream service"
  default     = 9091
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
      Module = "foundational-soa//runtime_ec2/modules/ec2",
      Name   = var.name
      Consul = "client"
    },
  var.tags)
}
