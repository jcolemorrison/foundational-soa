data "hcp_consul_cluster" "region" {
  cluster_id = var.consul_cluster_id
}

data "aws_instances" "ecs" {
  instance_tags = {
    "Name" = "${var.region}-ecs-instance"
  }
}