resource "consul_config_entry" "name" {
  kind = "service-intentions"
  name = "${local.us_east_1}-ecs-api"
  namespace = "default"
  partition = "ecs"
  config_json = jsonencode({
    Sources = [
      {
        Name = "${local.us_east_1}-ecs-upstream"
        Action = "allow"
        Peer = "prod-${local.us_east_1}"
        Namespace = "default"
        Partition = "ecs"
      },
      {
        Name = "${local.us_west_2}-ecs-upstream"
        Action = "allow"
        Peer = "prod-${local.us_west_2}"
        Namespace = "default"
        Partition = "ecs"
      },
      {
        Name = "${local.eu_west_1}-ecs-upstream"
        Action = "allow"
        Peer = "prod-${local.eu_west_1}"
        Namespace = "default"
        Partition = "ecs"
      }
    ]
  })
}