resource "aws_acm_certificate" "frontend" {
  domain_name               = var.subdomain_name
  validation_method         = "DNS"
  subject_alternative_names = [var.subdomain_name]
}

resource "aws_acm_certificate_validation" "frontend" {
  certificate_arn         = aws_acm_certificate.frontend.arn
  validation_record_fqdns = [for record in aws_route53_record.frontend_subdomain_validation : record.fqdn]
}