# Admin Partitions for ECS runtimes

resource "consul_admin_partition" "ecs_us_east_1" {
  name = "ecs-us-east-1"
  description = "Partition for ECS runtime in us-east-1"
  provider = consul.us_east_1
}

resource "consul_admin_partition" "ecs_us_west_2" {
  name = "ecs-us-west-2"
  description = "Partition for ECS runtime in us-west-2"
  provider = consul.us_west_2
}

resource "consul_admin_partition" "ecs_eu_west_1" {
  name = "ecs-eu-west-1"
  description = "Partition for ECS runtime in eu-west-1"
  provider = consul.eu_west_1
}