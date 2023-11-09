# Note: filter out wavelength zones if they're enabled in the account being deployed to.
data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "group-name"
    values = [var.aws_default_region]
  }
}

# Current region being deployed into
data "aws_region" "current" {}

# Current AWS Account being deployed into
data "aws_caller_identity" "current" {}

# Organization of the project
data "aws_organizations_organization" "current" {}

locals {
  runtime_ec2           = "10.1.0.0/16"
  runtime_ecs           = "10.2.0.0/16"
  runtime_eks_us_east_1 = "10.3.0.0/22"
  runtime_eks_us_west_2 = "10.3.4.0/22"
  runtime_eks_eu_west_1 = "10.3.8.0/22"
  runtime_frontend      = "10.4.0.0/16"
}