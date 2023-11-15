variable "terraform_cloud_organization" {
  type        = string
  description = "Terraform Cloud organization that outputs HCP Consul address, token, and datacenter"
}

variable "container_image" {
  type        = string
  description = "Container image for example application"
  default     = "nicholasjackson/fake-service:v0.26.0"
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace for example application"
  default     = "default"
}