data "kubernetes_service" "store_us_east_1" {
  metadata {
    name      = "store"
    namespace = var.namespace
  }
  provider = kubernetes.us_east_1
}

data "aws_elb" "lb_us_east_1" {
  name     = split("-", data.kubernetes_service.store_us_east_1.status[0].load_balancer[0].ingress[0].hostname).0
  provider = aws
}

data "kubernetes_service" "store_us_west_2" {
  metadata {
    name      = "store"
    namespace = var.namespace
  }
  provider = kubernetes.us_west_2
}

data "aws_elb" "lb_us_west_2" {
  name     = split("-", data.kubernetes_service.store_us_west_2.status[0].load_balancer[0].ingress[0].hostname).0
  provider = aws.us_west_2
}

data "kubernetes_service" "store_eu_west_1" {
  metadata {
    name      = "store"
    namespace = var.namespace
  }
  provider = kubernetes.eu_west_1
}

data "aws_elb" "lb_eu_west_1" {
  name     = split("-", data.kubernetes_service.store_eu_west_1.status[0].load_balancer[0].ingress[0].hostname).0
  provider = aws.eu_west_1
}

output "public_alb_dns_values" {
  value = {
    "us-east-1" = {
      dns_name = data.aws_elb.lb_us_east_1.dns_name
      zone_id  = data.aws_elb.lb_us_east_1.zone_id
    }
    "us-west-2" = {
      dns_name = data.aws_elb.lb_us_west_2.dns_name
      zone_id  = data.aws_elb.lb_us_west_2.zone_id
    }
    "eu-west-1" = {
      dns_name = data.aws_elb.lb_eu_west_1.dns_name
      zone_id  = data.aws_elb.lb_eu_west_1.zone_id
    }
  }
  description = "DNS Name and Zone ID of store service per region"
}
