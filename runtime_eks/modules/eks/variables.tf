variable "name" {
  type        = string
  description = "Name of EKS cluster"
}

variable "namespace" {
  type        = string
  description = "Namespace of valid service account for IAM roles to authenticate to EKS"
  default     = "kube-system"
}

variable "service_account" {
  type        = string
  description = "Name of valid service account for IAM roles to authenticate to EKS"
  default     = "aws-load-balancer-controller"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID of EKS cluster"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs, at least in two different availability zones"
}

variable "hcp_network_cidr_block" {
  type        = string
  description = "HCP network CIDR block for connection to HCP Consul"
}

variable "accessible_cidr_blocks" {
  type        = list(string)
  description = "List of routable CIDR blocks to allow Consul proxies to connect"
  default     = []
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
  description = "Path prefix for EKS cluster CloudWatch log group"
  default     = "/aws/eks"
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
    min_size        = number
    max_size        = number
    desired_size    = number
    instance_types  = list(string)
    labels          = map(string)
    max_unavailable = number
    capacity_type   = string
    ami_type        = string
    disk_size       = string
  })
  description = "Node group configuration"
  default = {
    min_size        = 1
    max_size        = 5
    desired_size    = 3
    instance_types  = null
    labels          = null
    max_unavailable = 1
    capacity_type   = "ON_DEMAND"
    ami_type        = "AL2_x86_64"
    disk_size       = 30
  }
}

variable "remote_access" {
  type = object({
    ec2_ssh_key               = string
    source_security_group_ids = list(string)
  })
  description = "Enable remote access to node groups"
  default     = null
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
      Module = "foundational-soa//runtime_eks/modules/eks",
      Name   = "${var.name}"
    },
  var.tags)
}
