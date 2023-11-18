## Sameness Groups

resource "consul_config_entry" "eu_west_1_ecs_sameness_group" {
  kind      = "sameness-group"
  name      = "ecs-sameness-group"
  partition = "ecs"

  config_json = jsonencode({
    DefaultForFailover = true
    IncludeLocal       = true
    Members = [
      { Peer = "${local.dc_us_east_1}-ecs" },
      { Peer = "${local.dc_us_west_2}-ecs" }
    ]
  })

  provider = consul.eu_west_1
}

## Service Exports

# resource "consul_config_entry" "eu_west_1_export_upstream" {
#   kind = "exported-services"
#   name = "ecs" # this is the partition
#   partition = "ecs" # unused

#   config_json = jsonencode({
#     # Name = "default"
#     Services = [
#       {
#         Name = "ecs-upstream"
#         Namespace = "default"
#         Consumers = [
#           {
#             SamenessGroup = "ecs-sameness-group"
#           }
#         ]
#       }
#     ]
#   })

#   depends_on = [ consul_config_entry.eu_west_1_ecs_sameness_group ]

#   provider = consul.eu_west_1
# }


## Service Intentions

# resource "consul_config_entry" "eu_west_1_api_to_upstreams" {
#   kind = "service-intentions"
#   name = "ecs-upstream"
#   namespace = "default"
#   partition = "ecs"
#   config_json = jsonencode({
#     Sources = [
#       {
#         Name = "ecs-api"
#         Action = "allow"
#         # Peer = "prod-${local.eu_west_1}-ecs"
#         Namespace = "default"
#         # Partition = "ecs"
#         SamenessGroup = "ecs-sameness-group"
#       }
#     ]
#   })

#   depends_on = [ consul_config_entry.eu_west_1_ecs_sameness_group ]

#   provider = consul.eu_west_1
# }