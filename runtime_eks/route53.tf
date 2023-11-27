locals {
  public_alb_dns_values = data.terraform_remote_state.shared_services_runtime_eks_applications.outputs.public_alb_dns_values
}

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


resource "aws_route53_record" "eks_public_endpoints" {
  for_each = local.public_alb_dns_values

  zone_id        = aws_route53_zone.subdomain.zone_id
  name           = var.public_subdomain_name
  type           = "A"
  set_identifier = "${each.key}-eks-public-api"

  alias {
    name                   = each.value.dns_name
    zone_id                = each.value.zone_id
    evaluate_target_health = true
  }

  latency_routing_policy {
    region = each.key
  }
}