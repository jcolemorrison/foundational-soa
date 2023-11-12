locals {
  subdomain = "${var.public_subdomain_name}.${var.public_domain_name}"
}

data "aws_route53_zone" "main" {
  name = var.public_domain_name
}

resource "aws_route53_zone" "subdomain" {
  name = local.subdomain
}

resource "aws_route53_record" "subdomain" {
  zone_id = aws_route53_zone.main.zone_id
  name    = local.subdomain
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.subdomain.name_servers
}

# Validation for subdomain certificate
resource "aws_route53_record" "subdomain_validation" {
  for_each = {
    for dvo in aws_acm_certificate.subdomain.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.main.zone_id
}