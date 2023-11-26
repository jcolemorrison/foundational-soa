resource "aws_lb" "mesh_gateway" {
  name               = var.name
  internal           = true
  load_balancer_type = "network"
  subnets            = var.public_subnet_ids
  security_groups    = var.security_group_ids

  tags = local.tags
}

resource "aws_lb_target_group" "mesh_gateway" {
  name     = var.name
  port     = 8443
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "mesh_gateway" {
  load_balancer_arn = aws_lb.mesh_gateway.arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mesh_gateway.arn
  }
}

resource "aws_lb_target_group_attachment" "mesh_gateway" {
  target_group_arn = aws_lb_target_group.mesh_gateway.arn
  target_id        = aws_instance.mesh_gateway.id
  port             = 8443
}
