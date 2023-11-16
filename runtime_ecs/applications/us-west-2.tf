## Sameness Groups

resource "consul_config_entry" "us_west_2_ecs_sameness_group" {
  kind      = "sameness-group"
  name      = "${local.us_west_2}-ecs-sameness-group"
  partition = "ecs"

  config_json = jsonencode({
    DefaultForFailover = true
    IncludeLocal       = true
    Members = [
      { Peer = "${local.dc_us_east_1}-ecs" },
      { Peer = "${local.dc_eu_west_1}-ecs" }
    ]
  })

  provider = consul.us_west_2
}

## Service Exports

resource "consul_config_entry" "us_west_2_export_upstream" {
  kind = "exported-services"
  name = "ecs"
  partition = "ecs"

  config_json = jsonencode({
    # Name = "default"
    Services = [
      {
        Name = "${local.us_west_2}-ecs-upstream"
        Consumers = [
          {
            SamenessGroup = "${local.us_west_2}-ecs-sameness-group"
          }
        ]
      }
    ]
  })

  provider = consul.us_west_2
}

## Service Intentions

resource "consul_config_entry" "us_west_2_api_to_upstreams" {
  kind = "service-intentions"
  name = "${local.us_west_2}-ecs-upstream"
  namespace = "default"
  partition = "ecs"
  config_json = jsonencode({
    Sources = [
      {
        Name = "${local.us_east_1}-ecs-api"
        Action = "allow"
        Peer = "${local.dc_us_east_1}-ecs"
        Namespace = "default"
        # Partition = "ecs"
      },
      {
        Name = "${local.us_west_2}-ecs-api"
        Action = "allow"
        # Peer = "prod-${local.us_west_2}-ecs"
        Namespace = "default"
        Partition = "ecs"
      },
      {
        Name = "${local.eu_west_1}-ecs-api"
        Action = "allow"
        Peer = "${local.dc_eu_west_1}-ecs"
        Namespace = "default"
        # Partition = "ecs"
      }
    ]
  })

  provider = consul.us_west_2
}