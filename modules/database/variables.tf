variable "global_cluster_id" {
  type        = string
  description = "RDS global cluster ID"
}

variable "database_engine_version" {
  type        = string
  description = "Engine version from global cluster"
}

variable "database_engine" {
  type        = string
  description = "Engine from global cluster"
}

variable "database_port" {
  type        = number
  description = "Database port"
  default     = 5432
}

variable "db_instance_class" {
  type        = string
  default     = "db.r6i.large"
  description = "Database instance class"
}

variable "is_primary" {
  type        = bool
  default     = false
  description = "Database is the primary instance"
}

variable "db_name" {
  type        = string
  description = "Database name to create in instance"
}

variable "service" {
  type        = string
  description = "Name of service to identify instance"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs, at least in two different availability zones"
}

variable "hcp_network_cidr_block" {
  type        = string
  description = "HCP network CIDR block for connection to HCP Vault and Consul"
}

variable "accessible_cidr_blocks" {
  type        = list(string)
  description = "List of routable CIDR blocks to allow Consul proxies to connect"
  default     = []
}

variable "boundary_worker_security_group_id" {
  type        = string
  description = "Boundary worker security group ID"
}
