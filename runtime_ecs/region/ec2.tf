data "aws_ssm_parameter" "ecs_optimized_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2023/recommended"
}

resource "aws_launch_template" "container_instance" {
  description = "launch template for ECS container instances"
  image_id = data.aws_ssm_parameter.ecs_optimized_ami.value
  instance_type = var.instance_type
  key_name = var.ecs_keypair
  name_prefix = "${var_region}-ecs-instance-"
  vpc_security_group_ids = [aws_security_group.container_instance.id]

  iam_instance_profile {
    arn = aws_iam_instance_profile.container_instance_profile.arn
  }

  monitoring {
    enabled = true
  }

  user_data = base64encode(templatefile("${path.module}/scripts/container_instance.sh", {
    ECS_CLUSTER_NAME = aws_ecs_cluster.main.name
  }))
}

resource "aws_autoscaling_group" "container_instance" {
  health_check_type = "EC2"
  max_size = var.max_container_instances
  min_size = var.min_container_instances
  name_prefix = "${var_region}-ecs-instance-"
  protect_from_scale_in = true
  target_group_arns = []
  vpc_zone_identifier = [ module.network.vpc_private_subnet_ids ]

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
    "GroupInServiceCapacity",
    "GroupPendingCapacity",
    "GroupStandbyCapacity",
    "GroupTerminatingCapacity",
    "GroupTotalCapacity"
  ]

  instance_refresh {
    strategy = "Rolling"
  }

  launch_template {
    id = aws_launch_template.container_instance.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key = "Name"
    value = "${var_region}-ecs-instance"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "container_instance" {
  name_prefix = "${var.region}-ecs-instance-"
  description = "security group for ECS container instances"
  vpc_id = module.network.vpc_id
}

resource "aws_security_group_rule" "container_instance_allow_ephemeral" {
  type = "ingress"
  from_port = 49153
  to_port = 65535
  protocol = "tcp"
  security_group_id = aws_security_group.container_instance.id
}

resource "aws_security_group_rule" "container_instance_allow_egress" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.container_instance.id
}