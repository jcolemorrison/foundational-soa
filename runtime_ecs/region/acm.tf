locals {
  certificate_subdomain = "${var.public_subdomain_name}.${var.public_domain_name}"
}

resource "aws_acm_certificate" "subdomain" {
  domain_name = var.public_domain_name
  validation_method = "DNS"
  subject_alternative_names = [local.certificate_subdomain]
}

resource "aws_acm_certificate_validation" "subdomain" {
  certificate_arn = aws_acm_certificate.subdomain.arn
  validation_record_fqdns = [ for record in aws_route53_record.subdomain_validation : record.fdqn ]
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
  zone_id         = var.subdomain_zone_id
}