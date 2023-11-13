resource "aws_ecs_service" "ecs_api" {
  name = "ecs-api"
  cluster = aws_ecs_cluster.main.arn
  desired_count = var.api_desired_count
  deployment_minimum_healthy_percent = var.api_deployment_minimum_healthy_percent
  deployment_maximum_percent = var.api_deployment_maximum_percent
  iam_role = var.ecs_service_role
  task_definition = module.ecs_api.task_definition.arn

  load_balancer {
    target_group_arn = aws_alb_target_group.public_alb_targets.arn
    container_name = "api"
    container_port = 9090
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }
  
  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}

module "ecs_controller" {
  source = "hashicorp/consul-ecs/aws//modules/acl-controller"
  version = "0.7.0"

  ecs_cluster_arn = aws_ecs_cluster.main.arn
  launch_type = "EC2"
  region = var.region
  subnets = module.vpc.private_subnets

  log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group = aws_cloudwatch_log_group.ecs_controller.name
      awslogs-region = var.region
      awslogs-stream-prefix = "consul-ecs-controller"
    }
  }

  consul_ecs_image = var.consul_ecs_image
  consul_bootstrap_token_secret_arn = aws_secretsmanager_secret.bootstrap_token.arn
  consul_partitions_enabled = true
  consul_partition = var.consul_admin_partition
  consul_server_hosts = var.consul_server_hosts
  tls = true
}

## AutoScaling for Tasks

resource "aws_appautoscaling_target" "ecs_api" {
  max_capacity = var.api_task_max_count
  min_capacity = var.api_task_min_count
  resource_id = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.ecs_api.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_api_cpu" {
  name = "ecs_api_cpu_target_tracking"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.ecs_api.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_api.scalable_dimension
  service_namespace = aws_appautoscaling_target.ecs_api.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 70

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

resource "aws_appautoscaling_policy" "ecs_api_memory" {
  name = "ecs_api_cpu_target_tracking"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.ecs_api.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_api.scalable_dimension
  service_namespace = aws_appautoscaling_target.ecs_api.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 70

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
  }
}