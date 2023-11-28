data "aws_lb" "lb_us_east_1" {
  tags = {
    "elbv2.k8s.aws/cluster" = local.cluster_name
    "service.k8s.aws/stack" = "${var.namespace}/store"
  }
  provider = aws
}

data "aws_lb" "lb_us_west_2" {
  tags = {
    "elbv2.k8s.aws/cluster" = local.cluster_name
    "service.k8s.aws/stack" = "${var.namespace}/store"
  }
  provider = aws.us_west_2
}

data "aws_lb" "lb_eu_west_1" {
  tags = {
    "elbv2.k8s.aws/cluster" = local.cluster_name
    "service.k8s.aws/stack" = "${var.namespace}/store"
  }
  provider = aws.eu_west_1
}

output "public_alb_dns_values" {
  value = {
    "us-east-1" = {
      dns_name = data.aws_lb.lb_us_east_1.dns_name
      zone_id  = data.aws_lb.lb_us_east_1.zone_id
    }
    "us-west-2" = {
      dns_name = data.aws_lb.lb_us_west_2.dns_name
      zone_id  = data.aws_lb.lb_us_west_2.zone_id
    }
    "eu-west-1" = {
      dns_name = data.aws_lb.lb_eu_west_1.dns_name
      zone_id  = data.aws_lb.lb_eu_west_1.zone_id
    }
  }
  description = "DNS Name and Zone ID of store service per region"
}
