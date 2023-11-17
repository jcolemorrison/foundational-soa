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
          value = "Hello from the ecs api in ${var.region} change"
        },
        {
          name = "UPSTREAM_URIS"
          value = "http://localhost:1234"
        }
      ]
    }
  ]

  upstreams = [
    {
      destinationName = "ecs-upstream" #consul service name
      localBindPort = 1234
      # meshGateway = {
      #   mode = "local"
      # }
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
  port = "9090"
  tls = true
  consul_ecs_image = var.consul_ecs_image
  consul_dataplane_image = var.consul_dataplane_image
  consul_namespace = var.consul_namespace
  consul_partition = var.consul_admin_partition
  consul_ca_cert_arn = aws_secretsmanager_secret.consul_ca_cert.arn
  consul_server_hosts = var.consul_server_hosts
  consul_service_name = "ecs-api"

  # http_config = {
  #   port = 443
  # }
  grpc_config = {
    port = 8502
  }
}

module "ecs_upstream" {
  source = "hashicorp/consul-ecs/aws//modules/mesh-task"
  version = "0.7.0"

  family = "${var.region}-ecs-upstream"

  cpu = 128
  memory = 256
  requires_compatibilities = ["EC2"]

  container_definitions = [
    {
      name = "upstream"
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
          awslogs-group         = aws_cloudwatch_log_group.ecs_upstream.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "container-"
        }
      }

      environment = [
        {
          name = "NAME"
          value = "ecs-upstream" 
        },
        {
          name = "MESSAGE"
          value = "Hello from the ecs upstream in ${var.region}"
        }
        # {
        #   name = "ERROR_RATE"
        #   value = var.region == "us-east-1" ? "100" : "0" // to simulate outage
        # }
      ]
    }
  ]

  log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.ecs_upstream.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "task-"
    }
  }

  additional_task_role_policies = [var.execute_command_policy]

  acls = true
  port = "9090"
  tls = true
  consul_ecs_image = var.consul_ecs_image
  consul_dataplane_image = var.consul_dataplane_image
  consul_namespace = var.consul_namespace
  consul_partition = var.consul_admin_partition
  consul_ca_cert_arn = aws_secretsmanager_secret.consul_ca_cert.arn
  consul_server_hosts = var.consul_server_hosts
  consul_service_name = "ecs-upstream"

  # http_config = {
  #   port = 443
  # }
  grpc_config = {
    port = 8502
  }
}