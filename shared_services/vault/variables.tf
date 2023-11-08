variable "terraform_cloud_organization" {
  type        = string
  description = "Terraform Cloud organization that outputs HCP Consul address, token, and datacenter"
}

# AWS Certificate Manager attributes
variable "certificate_common_name" {
  type        = string
  description = "Common name for certificate"
}