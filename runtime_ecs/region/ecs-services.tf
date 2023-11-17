## ECS API Service

resource "aws_ecs_service" "ecs_api" {
  name = "ecs-api"
  cluster = aws_ecs_cluster.main.arn
  desired_count = var.api_desired_count
  deployment_minimum_healthy_percent = var.api_deployment_minimum_healthy_percent
  deployment_maximum_percent = var.api_deployment_maximum_percent
  # iam_role = var.ecs_service_role # service linked role exists
  enable_execute_command = true
  launch_type = "EC2"
  propagate_tags = "TASK_DEFINITION"
  task_definition = module.ecs_api.task_definition_arn

  load_balancer {
    target_group_arn = aws_lb_target_group.public_alb_targets.arn
    container_name = "api"
    container_port = 9090
  }

  network_configuration {
    subnets = module.network.vpc_private_subnet_ids
    security_groups = [ aws_security_group.consul_client.id, aws_security_group.ecs_api.id ]
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

## ECS Upstream Service

resource "aws_ecs_service" "ecs_upstream" {
  name = "ecs-upstream"
  cluster = aws_ecs_cluster.main.arn
  desired_count = var.upstream_desired_count
  deployment_minimum_healthy_percent = var.upstream_deployment_minimum_healthy_percent
  deployment_maximum_percent = var.upstream_deployment_maximum_percent
  # iam_role = var.ecs_service_role # service linked role exists
  enable_execute_command = true
  launch_type = "EC2"
  propagate_tags = "TASK_DEFINITION"
  task_definition = module.ecs_upstream.task_definition_arn

  network_configuration {
    subnets = module.network.vpc_private_subnet_ids
    security_groups = [ aws_security_group.consul_client.id ]
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
  source = "hashicorp/consul-ecs/aws//modules/controller"
  version = "0.7.0"

  ecs_cluster_arn = aws_ecs_cluster.main.arn
  launch_type = "EC2"
  name_prefix = "${var.region}-ecs-controller"
  region = var.region
  security_groups = [ aws_security_group.consul_client.id ]
  subnets = module.network.vpc_private_subnet_ids

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

  http_config = {
    port = 443
  }
  grpc_config = {
    port = 8502
  }
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

## Consul Mesh Gateway

module "mesh_gateway" {
  source = "hashicorp/consul-ecs/aws//modules/gateway-task"
  version = "0.7.0"

  consul_server_hosts = var.consul_server_hosts
  ecs_cluster_arn = aws_ecs_cluster.main.arn
  family = "${var.region}-mesh-gateway"
  kind = "mesh-gateway"
  security_groups = [ aws_security_group.consul_client.id ]
  subnets = module.network.vpc_private_subnet_ids

  acls = true
  additional_task_role_policies = [var.execute_command_policy]
  consul_ca_cert_arn = aws_secretsmanager_secret.consul_ca_cert.arn
  consul_dataplane_image = var.consul_dataplane_image
  consul_ecs_image = var.consul_ecs_image
  consul_image = "public.ecr.aws/hashicorp/consul-enterprise:1.17-ent"
  consul_partition = var.consul_admin_partition
  launch_type = "EC2"
  # lb_create_security_group = false
  tls = true

  # http_config = {
  #   port = 443
  # }
  # grpc_config = {
  #   port = 8502
  # }

  lb_enabled = true
  lb_subnets = module.network.vpc_public_subnet_ids
  lb_vpc_id  = module.network.vpc_id

  log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.mesh_gateway.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "mesh-gatway-"
    }
  }
}