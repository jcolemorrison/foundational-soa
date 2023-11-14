variable "terraform_cloud_organization" {
  type        = string
  description = "Terraform Cloud organization that outputs HCP Consul address, token, and datacenter"
}

variable "runtimes" {
  type        = set(string)
  description = "Set of runtimes for Consul cluster peering"
  default     = ["eks", "ecs", "ec2", "frontend"]
}