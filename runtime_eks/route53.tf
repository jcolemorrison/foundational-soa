resource "aws_route53_zone" "subdomain" {
  name = var.public_subdomain_name
}

resource "aws_route53_record" "subdomain" {
  zone_id         = aws_route53_zone.subdomain.zone_id
  name            = var.public_subdomain_name
  type            = "NS"
  ttl             = "30"
  records         = aws_route53_zone.subdomain.name_servers
  allow_overwrite = true
}