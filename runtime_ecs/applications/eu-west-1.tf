## Service Intentions

resource "consul_config_entry" "eu_west_1_api_to_upstreams" {
  kind = "service-intentions"
  name = "${local.eu_west_1}-ecs-upstream"
  namespace = "default"
  partition = "ecs"
  config_json = jsonencode({
    Sources = [
      {
        Name = "${local.us_east_1}-ecs-api"
        Action = "allow"
        Peer = "prod-${local.us_east_1}-ecs"
        Namespace = "default"
        # Partition = "ecs"
      },
      {
        Name = "${local.us_west_2}-ecs-api"
        Action = "allow"
        Peer = "prod-${local.us_west_2}-ecs"
        Namespace = "default"
        # Partition = "ecs"
      },
      {
        Name = "${local.eu_west_1}-ecs-api"
        Action = "allow"
        # Peer = "prod-${local.eu_west_1}-ecs"
        Namespace = "default"
        Partition = "ecs"
      }
    ]
  })

  provider = consul.eu_west_1
}