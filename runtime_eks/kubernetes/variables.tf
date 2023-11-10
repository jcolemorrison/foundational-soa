variable "terraform_cloud_organization" {
  type        = string
  description = "Terraform Cloud organization that outputs HCP Consul address, token, and datacenter"
}

variable "hcp_consul_observability" {
  type = object({
    us_east_1 = object({
      client_id     = string
      client_secret = string
      resource_id   = string
    })
    us_west_2 = object({
      client_id     = string
      client_secret = string
      resource_id   = string
    })
    eu_west_1 = object({
      client_id     = string
      client_secret = string
      resource_id   = string
    })
  })
  description = "HCP Consul observability credentials for telemetry collector"
}