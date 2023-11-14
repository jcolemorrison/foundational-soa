locals {
  subdomain = "${var.public_subdomain_name}.${var.public_domain_name}"
}

resource "aws_route53_zone" "subdomain" {
  name = local.subdomain
}

resource "aws_route53_record" "subdomain" {
  zone_id = aws_route53_zone.subdomain.zone_id
  name    = local.subdomain
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.subdomain.name_servers
}