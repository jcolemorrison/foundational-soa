data "aws_instances" "eks" {
  instance_tags = {
    "eks:cluster-name" = var.name
  }
}
