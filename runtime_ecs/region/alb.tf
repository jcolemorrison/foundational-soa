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
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "public_alb_https_443" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.subdomain.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public_alb_targets.arn
  }
}