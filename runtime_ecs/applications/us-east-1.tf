## Sameness Groups

resource "consul_config_entry" "us_east_1_ecs_sameness_group" {
  kind      = "sameness-group"
  name      = "${local.us_east_1}-ecs-sameness-group"
  partition = "ecs"

  config_json = jsonencode({
    DefaultForFailover = true
    IncludeLocal       = true
    Members = [
      { Peer = "${local.us_west_2}-ecs" },
      { Peer = "${local.eu_west_1}-ecs" }
    ]
  })

  provider = consul.us_east_1
}

## Service Intentions

resource "consul_config_entry" "us_east_1_api_to_upstreams" {
  kind = "service-intentions"
  name = "${local.us_east_1}-ecs-upstream"
  namespace = "default"
  partition = "ecs"
  config_json = jsonencode({
    Sources = [
      {
        Name = "${local.us_east_1}-ecs-api"
        Action = "allow"
        # Peer = "prod-${local.us_east_1}-ecs"
        Namespace = "default"
        Partition = "ecs"
      },
      {
        Name = "${local.us_west_2}-ecs-api"
        Action = "allow"
        Peer = "prod-${local.us_west_2}-ecs" # Format = "{peer}-{partition}" i.e. "prod-us-west-2-ecs" where "prod-us-west-2" = peer and "ecs" = partition
        Namespace = "default"
        # Partition = "ecs"
      },
      {
        Name = "${local.eu_west_1}-ecs-api"
        Action = "allow"
        Peer = "prod-${local.eu_west_1}-ecs"
        Namespace = "default"
        # Partition = "ecs"
      }
    ]
  })

  provider = consul.us_east_1
}