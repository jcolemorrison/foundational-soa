module "ecs_api" {
  source  = "hashicorp/consul-ecs/aws//modules/mesh-task"
  version = "0.7.0"

  family = "${var.region}-ecs-api"

  cpu                      = 128
  memory                   = 256
  requires_compatibilities = ["EC2"]

  container_definitions = [
    {
      name      = "api"
      image     = "ghcr.io/nicholasjackson/fake-service:v0.26.0"
      cpu       = 0 # take up proportional cpu
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
          name  = "NAME"
          value = "HashiDemo API"
        },
        {
          name  = "MESSAGE"
          value = "Hello from the HashiDemo API in the ${var.region} region!"
        },
        {
          name  = "UPSTREAM_URIS"
          value = "http://localhost:1234,http://localhost:1235,${var.eks_upstream_uri}"
        }
      ]
    }
  ]

  upstreams = [
    {
      destinationName = "ecs-upstream" #consul service name
      localBindPort   = 1234
    },
    {
      destinationName = "ecs-upstream-users" #consul service name
      localBindPort   = 1235
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

  acls                   = true
  port                   = "9090"
  tls                    = true
  consul_ecs_image       = var.consul_ecs_image
  consul_dataplane_image = var.consul_dataplane_image
  consul_namespace       = var.consul_namespace
  consul_partition       = var.consul_admin_partition

  consul_server_hosts = var.consul_server_hosts
  consul_service_name = "ecs-api"

  http_config = {
    port = 443
  }
  grpc_config = {
    port = 8502
  }
}

module "ecs_upstream" {
  source  = "hashicorp/consul-ecs/aws//modules/mesh-task"
  version = "0.7.0"

  family = "${var.region}-ecs-upstream"

  cpu                      = 128
  memory                   = 256
  requires_compatibilities = ["EC2"]

  container_definitions = [
    {
      name      = "upstream"
      image     = "ghcr.io/nicholasjackson/fake-service:v0.26.0"
      cpu       = 0 # take up proportional cpu
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
          name  = "NAME"
          value = "Messages"
        },
        {
          name  = "MESSAGE"
          value = "Hello from the upstream Messages services in ${var.region} region!"
        },
        {
          name = "ERROR_RATE"
          value = var.region == "us-east-1" && var.test_failover ? "100" : "0" // to simulate outage
        },
        {
          name = "ERROR_TYPE"
          value = "delay" // to simulate outage
        },
        {
          name = "ERROR_DELAY"
          value = "30s" // to simulate outage
        }
      ]

      # healthCheck = {
      #   retries = 10
      #   command = [
      #       "CMD-SHELL",
      #       "curl -f http://localhost:9090/ || exit 1"
      #   ],
      #   timeout = 5,
      #   interval = 30,
      #   startPeriod = null
      # }
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

  acls                   = true
  port                   = "9090"
  tls                    = true
  consul_ecs_image       = var.consul_ecs_image
  consul_dataplane_image = var.consul_dataplane_image
  consul_namespace       = var.consul_namespace
  consul_partition       = var.consul_admin_partition

  consul_server_hosts = var.consul_server_hosts
  consul_service_name = "ecs-upstream"

  http_config = {
    port = 443
  }
  grpc_config = {
    port = 8502
  }
}

module "ecs_upstream_users" {
  source  = "hashicorp/consul-ecs/aws//modules/mesh-task"
  version = "0.7.0"

  family = "${var.region}-ecs-upstream-users"

  cpu                      = 128
  memory                   = 256
  requires_compatibilities = ["EC2"]

  container_definitions = [
    {
      name      = "upstream-users"
      image     = "ghcr.io/nicholasjackson/fake-service:v0.26.0"
      cpu       = 0 # take up proportional cpu
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
          awslogs-group         = aws_cloudwatch_log_group.ecs_upstream_users.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "container-"
        }
      }

      environment = [
        {
          name  = "NAME"
          value = "Users"
        },
        {
          name  = "MESSAGE"
          value = "Hello from the upstream Users services in ${var.region} region!"
        }
      ]
    }
  ]

  log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.ecs_upstream_users.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "task-"
    }
  }

  additional_task_role_policies = [var.execute_command_policy]

  acls                   = true
  port                   = "9090"
  tls                    = true
  consul_ecs_image       = var.consul_ecs_image
  consul_dataplane_image = var.consul_dataplane_image
  consul_namespace       = var.consul_namespace
  consul_partition       = var.consul_admin_partition

  consul_server_hosts = var.consul_server_hosts
  consul_service_name = "ecs-upstream-users"

  http_config = {
    port = 443
  }
  grpc_config = {
    port = 8502
  }
}