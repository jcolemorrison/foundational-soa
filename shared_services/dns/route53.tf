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

resource "aws_route53_record" "subdomain_frontend" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "app.${var.domain_name}"
  type    = "NS"
  ttl     = "30"
  records = data.terraform_remote_state.runtime_frontend.outputs.subdomain_name_servers
}