resource "consul_config_entry" "name" {
  kind = "service-intentions"
  name = "${locals.us_east_1}-ecs-api"
  namespace = "default"
  partition = "ecs"
  config_json = jsonencode({
    Sources = [
      {
        Name = "${locals.us_east_1}-ecs-upstream"
        Action = "allow"
        Peer = "prod-${locals.us_east_1}"
        Namespace = "default"
        Partition = "ecs"
      },
      {
        Name = "${locals.us_west_2}-ecs-upstream"
        Action = "allow"
        Peer = "prod-${locals.us_west_2}"
        Namespace = "default"
        Partition = "ecs"
      },
      {
        Name = "${locals.eu_west_1}-ecs-upstream"
        Action = "allow"
        Peer = "prod-${locals.eu_west_1}"
        Namespace = "default"
        Partition = "ecs"
      }
    ]
  })
}