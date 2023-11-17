resource "consul_config_entry_service_resolver" "us_east_1_upstream_test" {
  name = "ecs-upstream" # name of service this applies to, despite inaccurate docs
  namespace = "default"
  partition = "ecs"
  connect_timeout = "1s" # required fields
  request_timeout = "1s"

  redirect {
    service = "ecs-upstream"
    peer = "${local.dc_us_west_2}-ecs"
    namespace = "default"
  }

  provider = consul.us_east_1
}

## Service Intentions

resource "consul_config_entry" "us_east_1_api_to_upstreams" {
  kind = "service-intentions"
  name = "ecs-upstream"
  namespace = "default"
  partition = "ecs"
  config_json = jsonencode({
    Sources = [
      {
        Name = "ecs-api"
        Action = "allow"
        # Peer = "prod-${local.us_east_1}-ecs"
        Namespace = "default"
        Partition = "ecs"
        # SamenessGroup = "${local.us_east_1}-ecs-sameness-group"
      },
      {
        Name = "${local.us_west_2}-ecs-api"
        Action = "allow"
        Peer = "${local.dc_us_west_2}-ecs" # Format = "{peer}-{partition}" i.e. "prod-us-west-2-ecs" where "prod-us-west-2" = peer and "ecs" = partition
        Namespace = "default"
        # Partition = "ecs"
        # SamenessGroup = "${local.us_east_1}-ecs-sameness-group"
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
}

# ## Sameness Groups

# resource "consul_config_entry" "us_east_1_ecs_sameness_group" {
#   kind      = "sameness-group"
#   name      = "${local.us_east_1}-ecs-sameness-group"
#   partition = "ecs"

#   config_json = jsonencode({
#     DefaultForFailover = false
#     IncludeLocal       = true
#     Members = [
#       { Peer = "${local.dc_us_west_2}-ecs" },
#       { Peer = "${local.dc_eu_west_1}-ecs" }
#     ]
#   })

#   provider = consul.us_east_1
# }

# ## Service Intentions

# resource "consul_config_entry" "us_east_1_api_to_upstreams" {
#   kind = "service-intentions"
#   name = "ecs-upstream"
#   namespace = "default"
#   partition = "ecs"
#   config_json = jsonencode({
#     Sources = [
#       {
#         Name = "ecs-api"
#         Action = "allow"
#         # Peer = "prod-${local.us_east_1}-ecs"
#         Namespace = "default"
#         # Partition = "ecs"
#         SamenessGroup = "${local.us_east_1}-ecs-sameness-group"
#       }
#       # {
#       #   Name = "${local.us_west_2}-ecs-api"
#       #   Action = "allow"
#       #   Peer = "${local.dc_us_west_2}-ecs" # Format = "{peer}-{partition}" i.e. "prod-us-west-2-ecs" where "prod-us-west-2" = peer and "ecs" = partition
#       #   Namespace = "default"
#       #   # Partition = "ecs"
#       #   # SamenessGroup = "${local.us_east_1}-ecs-sameness-group"
#       # },
#       # {
#       #   Name = "${local.eu_west_1}-ecs-api"
#       #   Action = "allow"
#       #   Peer = "${local.dc_eu_west_1}-ecs"
#       #   Namespace = "default"
#       #   # Partition = "ecs"
#       # }
#     ]
#   })

#   provider = consul.us_east_1
# }

# ## Service Resolvers

# resource "consul_config_entry_service_resolver" "us_east_1_upstream_test" {
#   name = "ecs-upstream" # name of service this applies to, despite inaccurate docs
#   namespace = "default"
#   partition = "ecs"
#   connect_timeout = "1s" # required fields
#   request_timeout = "1s"

#   redirect {
#     service = "ecs-upstream"
#     peer = "${local.dc_us_west_2}-ecs"
#     namespace = "default"
#   }

#   provider = consul.us_east_1
# }