data "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_route53_record" "subdomain_ecs" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "ecs.${var.domain_name}"
  type    = "NS"
  ttl     = "30"
  records = data.terraform_remote_state.runtime_ecs.outputs.subdomain_name_servers
}

# Latency based routing
resource "aws_route53_record" "ecs_public_api" {
  for_each = ecs_public_api_dns_names

  zone_id = data.aws_route53_zone.main.zone_id
  name    = "ecs.${var.domain_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [each.value]

  latency_routing_policy {
    region = each.key
  }
}