resource "aws_route53_zone" "frontend" {
  name = var.subdomain_name
}

resource "aws_route53_record" "frontend" {
  zone_id         = aws_route53_zone.frontend.zone_id
  name            = var.subdomain_name
  type            = "NS"
  ttl             = "30"
  records         = aws_route53_zone.frontend.name_servers
  allow_overwrite = true
}

# Validation for subdomain certificate
resource "aws_route53_record" "frontend_subdomain_validation" {
  for_each = {
    for dvo in aws_acm_certificate.frontend.domain_validation_options : dvo.domain_name => {
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
  zone_id         = aws_route53_zone.frontend.zone_id
}

resource "aws_route53_record" "cloudfront" {
  zone_id = aws_route53_zone.frontend.zone_id
  name    = var.subdomain_name
  type    = "A"

  alias {
    name    = aws_cloudfront_distribution.frontend.domain_name
    zone_id = aws_cloudfront_distribution.frontend.hosted_zone_id
    evaluate_target_health = false
  }
  depends_on = [
    aws_cloudfront_distribution.frontend
  ]
}