data "aws_instances" "ec2" {
  instance_tags = merge(local.boundary_tag, local.application_tag)
}

data "aws_instances" "consul_mesh_gateway" {
  instance_tags = merge(local.boundary_tag, local.consul_tag)
}