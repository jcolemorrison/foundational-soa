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

variable "consul_partition" {
  type        = string
  description = "Consul partition for EKS cluster"
  default     = "default"
}

locals {
  service_ports = {
    web         = 9090
    application = 9090
    database    = 9090
  }

  peers = {
    us_east_1 = "${local.cluster_name}-us-east-1-${var.consul_partition}"
    us_west_2 = "${local.cluster_name}-us-west-2-${var.consul_partition}"
    eu_west_1 = "${local.cluster_name}-eu-west-1-${var.consul_partition}"
  }
}