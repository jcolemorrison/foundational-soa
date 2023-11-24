# Network Specific Variables
variable "vpc_cidr_block" {
  type        = string
  description = "Cidr block for the VPC.  Using a /22 Subnet Mask for this project is recommended."
}

variable "region" {
  type        = string
  description = "AWS region to deploy the transit gateway to.  Only used for naming purposes."
}

variable "runtime" {
  type        = string
  description = "Runtime"
  default     = "eks"
}

variable "transit_gateway_id" {
  type        = string
  description = "transit gateway ID to point traffic to for shared services, hcp, etc."
}

variable "shared_services_cidr_block" {
  type        = string
  description = "CIDR block of the shared services sandbox."
}

variable "hcp_hvn_cidr_block" {
  type        = string
  description = "CIDR block of the HCP HVN."
}

variable "accessible_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks to point to the transit gateway in addition to the Shared Services sandbox and HCP HVN"
  default     = []
}

variable "name" {
  type        = string
  description = "Name of regional resources"
}

## EKS Cluster

variable "create_eks_cluster" {
  type        = bool
  description = "Create EKS cluster"
  default     = false
}

## Boundary workers

variable "create_boundary_workers" {
  type        = bool
  description = "Create Boundary workers, one per public subnet"
  default     = false
}

variable "keypair" {
  type        = string
  description = "Keypair"
  default     = null
}

variable "remote_access" {
  type = list(object({
    ec2_ssh_key               = string
    source_security_group_ids = list(string)
  }))
  description = "Allow SSH access to initial node group"
  default     = null
}

variable "vault_address" {
  type        = string
  description = "Vault cluster address"
  default     = null
}

variable "vault_namespace" {
  type        = string
  description = "Vault cluster namespace"
  default     = null
}

variable "boundary_worker_vault_namespace" {
  type        = string
  description = "Namespace in Vault for Boundary worker to store secret"
  default     = null
}

variable "boundary_worker_vault_namespace_absolute" {
  type        = string
  description = "Namespace in Vault for Boundary worker to store secret, includes full path"
  default     = null
}

variable "boundary_worker_vault_path" {
  type        = string
  description = "Path in Vault for Boundary worker to store secret"
  default     = null
}

variable "boundary_worker_vault_token" {
  type        = string
  description = "Token in Vault for Boundary worker to store secret"
  sensitive   = true
  default     = null
}

variable "boundary_cluster_id" {
  type        = string
  description = "Boundary cluster ID for workers to register"
  default     = null
}

variable "boundary_project_scope_id" {
  type        = string
  description = "Boundary project scope ID for EKS runtime"
}

## Database

variable "create_database" {
  type        = bool
  description = "Create database instance"
  default     = false
}

variable "global_cluster_id" {
  type        = string
  description = "RDS global cluster ID"
  default     = null
}

variable "database_engine_version" {
  type        = string
  description = "Engine version from global cluster"
  default     = null
}

variable "database_engine" {
  type        = string
  description = "Engine from global cluster"
  default     = null
}

variable "is_database_primary" {
  type        = bool
  default     = false
  description = "Database is the primary instance"
}

variable "db_name" {
  type        = string
  description = "Database name to create in instance"
  default     = null
}
