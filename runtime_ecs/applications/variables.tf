locals {
  us_east_1 = "us-east-1"
  us_west_2 = "us-west-2"
  eu_west_1 = "eu-west-1"
  dc_us_east_1 = "prod-${us_east_1}"
  dc_us_west_2 = "prod-${us_west_2}"
  dc_eu_west_1 = "prod-${eu_west_1}"
}

variable "terraform_cloud_organization" {
  type        = string
  description = "Terraform Cloud organization that outputs HCP Consul address, token, and datacenter"
}