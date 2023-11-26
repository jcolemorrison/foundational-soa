data "aws_instances" "ec2" {
  instance_tags = local.boundary_tag
}