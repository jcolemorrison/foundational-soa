# VPC
module "us_east_1_vpc" {
  source = "../../modules/vpc"
  cidr_block = var.vpc_cidr_block
  name = "${var.region}-network"
}

# Transit Gateway and RAM Shares
resource "aws_ec2_transit_gateway" "main" {
  description = "transit gateway for ${var.region}"

  amazon_side_asn = var.tgw_asn
  auto_accept_shared_attachments = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  dns_support = "enable"
  multicast_support = "disable"
  transit_gateway_cidr_blocks = [var.tgw_cidr_block]

  tags = merge({ "Name" = "${var.region}-tgw" }, var.tags)
}

resource "aws_ram_resource_share" "main" {
  name                      = "${var.region}-tgw"
  allow_external_principals = true

  tags = { "Name" = "${var.region}-tgw-ram" }
}

resource "aws_ram_resource_association" "main" {
  resource_arn       = aws_ec2_transit_gateway.main.arn
  resource_share_arn = aws_ram_resource_share.main.arn
}

resource "aws_ram_principal_association" "organization" {
  resource_share_arn = aws_ram_resource_share.main.arn
  principal = var.organization_arn
}

resource "aws_ram_principal_association" "external" {
  count              = var.external_principals > 0 ? var.external_principals : 0
  principal          = var.external_principals[count.index]
  resource_share_arn = aws_ram_resource_share.main.arn
}