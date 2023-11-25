resource "aws_ecs_cluster" "main" {
  name = "${var.region}-cluster"
}

# resource "aws_ecs_capacity_provider" "main" {
#   name = "${var.region}-cluster"

#   auto_scaling_group_provider {
#     auto_scaling_group_arn         = aws_autoscaling_group.container_instance.arn
#     managed_termination_protection = "ENABLED"

#     managed_scaling {
#       maximum_scaling_step_size = var.max_scaling_step_size
#       minimum_scaling_step_size = var.min_scaling_step_size
#       status                    = "ENABLED"
#       target_capacity           = var.scaling_target_capacity_size
#     }
#   }
# }

# resource "aws_ecs_cluster_capacity_providers" "main" {
#   cluster_name       = aws_ecs_cluster.main.name
#   capacity_providers = [aws_ecs_capacity_provider.main.name]
# }