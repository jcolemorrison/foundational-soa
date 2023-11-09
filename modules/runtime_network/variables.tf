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

variable "attach_public_subnets" {
  type        = bool
  description = "Attach public subnets instead of private subnets to transit gateway"
  default     = true
}
