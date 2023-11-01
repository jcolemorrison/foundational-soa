resource "hcp_hvn" "hvn" {
  hvn_id         = var.hvn_name
  cloud_provider = "aws"
  region         = var.hvn_region
  cidr_block     = var.hvn_cidr_block
}

resource "aws_ram_resource_share" "transit" {
  name                      = var.hvn_name
  allow_external_principals = true
  tags                      = local.tags
}

resource "aws_ram_principal_association" "transit" {
  resource_share_arn = aws_ram_resource_share.transit.arn
  principal          = hcp_hvn.hvn.provider_account_id
}

resource "aws_ram_resource_association" "transit" {
  resource_share_arn = aws_ram_resource_share.transit.arn
  resource_arn       = var.transit_gateway_arn
}

resource "hcp_aws_transit_gateway_attachment" "transit" {
  depends_on = [
    aws_ram_principal_association.transit,
    aws_ram_resource_association.transit,
  ]

  hvn_id                        = hcp_hvn.hvn.hvn_id
  transit_gateway_attachment_id = var.hvn_name
  transit_gateway_id            = var.transit_gateway_id
  resource_share_arn            = aws_ram_resource_share.transit.arn
}

resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "this" {
  transit_gateway_attachment_id = hcp_aws_transit_gateway_attachment.transit.provider_transit_gateway_attachment_id
  tags                          = local.tags
}