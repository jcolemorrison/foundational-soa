variable "name" {
  type        = string
  description = "Name of EKS cluster"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID of EKS cluster"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs, at least in two different availability zones"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs, at least in two different availability zones"
}

variable "enable_default_eks_policy" {
  type        = bool
  description = "Enable default EKS policy"
  default     = true
}

variable "cluster_additional_security_group_ids" {
  type        = list(string)
  description = "Additional cluster security group IDs"
  default     = []
}

variable "node_security_group_additional_rules" {
  type        = map(string)
  description = "Additional rules for main node group"
  default     = {}
}

variable "cluster_version" {
  type        = string
  description = "Cluster Kubernetes version. If not defined, latest available at creation"
  default     = null
}

variable "endpoint_private_access" {
  type        = bool
  description = "Private API server endpoint is enabled"
  default     = true
}

variable "endpoint_public_access" {
  type        = bool
  description = "Public API server endpoint is enabled"
  default     = true
}

variable "path_prefix" {
  type        = string
  description = "Path prefix for EKS cluster IAM role and CloudWatch log group"
  default     = "/eks"
}

variable "eks_cluster_iam_role_additional_policies" {
  type        = map(string)
  description = "Additional IAM policies for EKS cluster role"
  default     = {}
}

variable "node_group_iam_role_additional_policies" {
  type        = map(string)
  description = "Additional IAM policies for node group role"
  default     = {}
}

variable "node_group_config" {
  type = object({
    name            = string
    min_size        = number
    max_size        = number
    desired_size    = number
    instance_types  = list(string)
    labels          = map(string)
    max_unavailable = number
    capacity_type   = string
    ami_type        = string
  })
  description = "Node group configuration"
  default = {
    name            = "main"
    min_size        = 1
    max_size        = 5
    desired_size    = 3
    instance_types  = null
    labels          = null
    max_unavailable = 1
    capacity_type   = "ON_DEMAND"
    ami_type        = "AL2_x86_64"
  }
}

variable "remote_access" {
  type = list(object({
    ec2_ssh_key               = string
    source_security_group_ids = list(string)
  }))
  description = "Allow SSH access to initial node group"
  default     = []
}

variable "key_owners" {
  type        = list(string)
  description = "Owners of key allowed for all KMS key operations"
  default     = []
}

variable "key_users" {
  type        = list(string)
  description = "Users of key allowed to encrypt/decrypt with KMS key for cluster"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Additional tags for EKS cluster"
  default     = {}
}

locals {
  tags = merge(
    {
      Module = "foundational-soa//modules/eks",
      Name   = "${var.name}"
    },
  var.tags)
}