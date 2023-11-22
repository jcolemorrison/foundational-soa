data "aws_instances" "eks" {
  instance_tags = {
    "eks:cluster-name" = var.name
  }
}

data "aws_lbs" "consul_api_gateway" {
  tags = {
    "elbv2.k8s.aws/cluster" = var.name
    "service.k8s.aws/stack" = "consul/api-gateway"
  }
}

# data "aws_lb" "consul_api_gateway" {
#   for_each = toset(data.aws_lbs.consul_api_gateway.arns)
#   arn      = each.value
# }