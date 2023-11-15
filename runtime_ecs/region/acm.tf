locals {
  certificate_subdomain = "${var.public_subdomain_name}.${var.public_domain_name}"
}

resource "aws_acm_certificate" "subdomain" {
  domain_name = local.certificate_subdomain
  validation_method = "DNS"
  subject_alternative_names = [local.certificate_subdomain]
}

resource "aws_acm_certificate_validation" "subdomain" {
  certificate_arn = aws_acm_certificate.subdomain.arn
  validation_record_fqdns = [ for record in aws_route53_record.subdomain_validation : record.fqdn ]
}