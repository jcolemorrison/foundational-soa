locals {
  subdomain = "${var.public_subdomain_name}.${var.public_domain_name}"
  public_alb_dns_values = [
    module.us_east_1.public_alb_dns_values,
    module.us_west_2.public_alb_dns_values,
    module.eu_west_1.public_alb_dns_values
  ]
}

resource "aws_route53_zone" "subdomain" {
  name = local.subdomain
}

resource "aws_route53_record" "subdomain" {
  zone_id         = aws_route53_zone.subdomain.zone_id
  name            = local.subdomain
  type            = "NS"
  ttl             = "30"
  records         = aws_route53_zone.subdomain.name_servers
  allow_overwrite = true
}


resource "aws_route53_record" "ecs_public_api" {
  for_each = {for i, values in local.local.public_alb_dns_values : i => values }

  zone_id = aws_route53_zone.subdomain.zone_id
  name    = local.subdomain
  type    = "A"
  set_identifier = "${each.value.region}-ecs-public-api"

  alias {
    name = each.value.dns_name
    zone_id = each.value.zone_id
    evaluate_target_health = true
  }

  latency_routing_policy {
    region = each.value.region
  }
}