resource "aws_acm_certificate" "subdomain" {
  domain_name               = var.public_subdomain_name
  validation_method         = "DNS"
  subject_alternative_names = [var.public_subdomain_name]
}

resource "aws_acm_certificate_validation" "subdomain" {
  certificate_arn         = aws_acm_certificate.subdomain.arn
  validation_record_fqdns = [for record in aws_route53_record.subdomain_validation : record.fqdn]
}