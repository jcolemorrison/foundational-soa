## Sameness Groups

resource "consul_config_entry" "us_east_1_ecs_sameness_group" {
  kind      = "sameness-group"
  name      = "ecs-sameness-group"
  partition = "ecs"

  config_json = jsonencode({
    DefaultForFailover = true
    IncludeLocal       = true
    Members = [
      { Peer = "${local.dc_us_west_2}-ecs" },
      { Peer = "${local.dc_eu_west_1}-ecs" }
    ]
  })

  provider = consul.us_east_1
}

## Service Exports

resource "consul_config_entry" "us_east_1_export_upstream" {
  kind      = "exported-services"
  name      = "ecs" # this is the partition
  partition = "ecs" # unused

  config_json = jsonencode({
    # Name = "default"
    Services = [
      {
        Name      = "ecs-upstream"
        Namespace = "default"
        Consumers = [
          {
            SamenessGroup = "ecs-sameness-group"
          }
        ]
      },
      {
        Name      = "ecs-upstream-users"
        Namespace = "default"
        Consumers = [
          {
            SamenessGroup = "ecs-sameness-group"
          }
        ]
      }
    ]
  })

  depends_on = [consul_config_entry.us_east_1_ecs_sameness_group]

  provider = consul.us_east_1
}

## Service Intentions

resource "consul_config_entry" "us_east_1_api_to_upstreams" {
  kind      = "service-intentions"
  name      = "ecs-upstream"
  namespace = "default"
  partition = "ecs"
  config_json = jsonencode({
    Sources = [
      {
        Name   = "ecs-api"
        Action = "allow"
        # Peer = "prod-${local.us_east_1}-ecs"
        Namespace = "default"
        # Partition = "ecs"
        SamenessGroup = "ecs-sameness-group"
      }
    ]
  })

  depends_on = [consul_config_entry.us_east_1_ecs_sameness_group]

  provider = consul.us_east_1
}

resource "consul_config_entry" "us_east_1_api_to_upstream_users" {
  kind      = "service-intentions"
  name      = "ecs-upstream-users"
  namespace = "default"
  partition = "ecs"
  config_json = jsonencode({
    Sources = [
      {
        Name   = "ecs-api"
        Action = "allow"
        # Peer = "prod-${local.us_east_1}-ecs"
        Namespace = "default"
        # Partition = "ecs"
        SamenessGroup = "ecs-sameness-group"
      }
    ]
  })

  depends_on = [consul_config_entry.us_east_1_ecs_sameness_group]

  provider = consul.us_east_1
}

## Service Resolvers

# resource "consul_config_entry" "us_east_1_sameness_failover_resolver" {
#   name = "ecs-upstream"
#   kind = "service-resolver"
#   partition = "ecs"
#   namespace = "default"

#   config_json = jsonencode({
#     connectTimeout = "0s"
#     failover = {
#       "*" = {
#         SamenessGroup = "ecs-sameness-group"
#       }
#     }
#   })

#   depends_on = [ consul_config_entry.us_east_1_ecs_sameness_group ]

#   provider = consul.us_east_1
# }

# resource "consul_config_entry" "us_east_1_sameness_users_failover_resolver" {
#   name = "ecs-upstream-users"
#   kind = "service-resolver"
#   partition = "ecs"
#   namespace = "default"

#   config_json = jsonencode({
#     connectTimeout = "0s"
#     failover = {
#       "*" = {
#         SamenessGroup = "ecs-sameness-group"
#       }
#     }
#   })

#   depends_on = [ consul_config_entry.us_east_1_ecs_sameness_group ]

#   provider = consul.us_east_1
# }

# resource "consul_config_entry" "us_east_1_ecs_api_to_ec2_payments" {
#   kind = "service-resolver"
#   name = "payments"
#   partition = "ecs"
#   namespace = "default"

#   config_json = jsonencode({
#     Redirect = {
#       Service = "payments"
#       Peer    = "prod-${local.us_east_1}-ec2"
#     }
#   })

#   provider = consul.us_east_1
# }

# resource "consul_acl_policy" "us_east_1_cross_partition_access" {
#   name = "us_east_1_cross_partition_access"

#   rules = <<-RULE
#   operator = "write"
#   agent_prefix "" {
#     policy = "read"
#   }
#   partition_prefix "" {
#     namespace_prefix "" {
#       acl = "write"
#       service_prefix "" {
#         policy = "write"
#       }
#     }
#   }
#   RULE

#   provider = consul.us_east_1
# }