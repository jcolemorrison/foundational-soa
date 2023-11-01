resource "hcp_hvn" "hvn" {
  hvn_id         = var.hvn_name
  cloud_provider = "aws"
  region         = var.hvn_region
  cidr_block     = var.hvn_cidr_block
}

resource "aws_ram_principal_association" "transit" {
  resource_share_arn = var.aws_ram_resource_share_arn
  principal          = hcp_hvn.hvn.provider_account_id
}

resource "hcp_aws_transit_gateway_attachment" "hcp" {
  depends_on = [
    aws_ram_principal_association.transit
  ]

  hvn_id                        = hcp_hvn.hvn.hvn_id
  transit_gateway_attachment_id = var.hvn_name
  transit_gateway_id            = var.transit_gateway_id
  resource_share_arn            = var.aws_ram_resource_share_arn
}

resource "hcp_hvn_route" "route" {
  hvn_link         = hcp_hvn.hvn.self_link
  hvn_route_id     = "${var.hvn_name}-hvn-to-tgw-attachment"
  destination_cidr = var.vpc_cidr_block
  target_link      = hcp_aws_transit_gateway_attachment.hcp.self_link
}

resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "hcp" {
  depends_on                    = [hcp_aws_transit_gateway_attachment.hcp]
  transit_gateway_attachment_id = hcp_aws_transit_gateway_attachment.hcp.provider_transit_gateway_attachment_id
  tags                          = local.tags
}