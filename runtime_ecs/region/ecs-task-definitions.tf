module "ecs_api" {
  source = "hashicorp/consul-ecs/aws//modules/mesh-task"
  version = "0.7.0"

  family = "${var.region}-ecs-api"

  cpu = 128
  memory = 256
  requires_compatibilities = ["EC2"]

  container_definitions = [
    {
      name = "api"
      image = "ghcr.io/nicholasjackson/fake-service:v0.26.0"
      cpu = 0 # take up proportional cpu
      essential = true

      portMappings = [
        {
          containerPort = 9090
          # hostPort = 9090 # omitting maps to ephemeral port on host
          protocol = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_api.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "container-"
        }
      }

      environment = [
        {
          name = "NAME"
          value = "ecs-api" 
        },
        {
          name = "MESSAGE"
          value = "Hello from the ecs api"
        },
      ]
    }
  ]

  log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.ecs_api.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "task-"
    }
  }

  additional_task_role_policies = [var.execute_command_policy]

  acls = true
  tls = true
  consul_ecs_image = var.consul_ecs_image
  consul_dataplane_image = var.consul_dataplane_image
  consul_namespace = var.consul_namespace
  consul_partition = var.consul_admin_partition
  consul_server_hosts = var.consul_server_hosts
}