# Network Specific Variables
variable "vpc_cidr_block" {
  type        = string
  description = "Cidr block for the VPC.  Using a /22 Subnet Mask for this project is recommended."
}

variable "region" {
  type        = string
  description = "AWS region to deploy the transit gateway to.  Only used for naming purposes."
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

variable "cluster_name" {
  type        = string
  description = "Name of EKS cluster"
  default     = null
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