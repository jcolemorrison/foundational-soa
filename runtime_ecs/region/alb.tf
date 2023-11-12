# Load balancer for public facing targets
resource "aws_lb" "public_alb" {
  name_prefix        = "pb-"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_alb.id]
  subnets            = module.network.vpc_public_subnet_ids
  idle_timeout       = 60
  ip_address_type    = "dualstack"

  tags = { "Name" = "${var.region}-public-alb" }
}

resource "aws_lb_target_group" "public_alb_targets" {
  name_prefix          = "cl-"
  port                 = 9090
  protocol             = "HTTP"
  vpc_id               = module.network.vpc_id
  deregistration_delay = 30
  target_type          = "ip"

  health_check {
    enabled             = true
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 30
    interval            = 60
    protocol            = "HTTP"
  }

  tags = { "Name" = "${var.region}-public-tg" }
}

resource "aws_lb_listener" "public_alb_http_80" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public_alb_targets.arn
  }
}

# Security Group for Public ALB
resource "aws_security_group" "public_alb" {
  name_prefix = "${var.region}-ecs-public-alb"
  description = "security group for public load balancer"
  vpc_id      = module.network.vpc_id
}

resource "aws_security_group_rule" "public_alb_allow_80" {
  security_group_id = aws_security_group.public_alb.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow HTTP traffic."
}

resource "aws_security_group_rule" "public_alb_allow_outbound" {
  security_group_id = aws_security_group.public_alb.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow any outbound traffic."
}