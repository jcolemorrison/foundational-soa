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