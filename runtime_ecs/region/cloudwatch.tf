resource "aws_cloudwatch_log_group" "ecs_controller" {
  name_prefix = "ecs-controller-"
}

resource "aws_cloudwatch_log_group" "ecs_api" {
  name_prefix = "ecs-api-"
}

resource "aws_cloudwatch_log_group" "ecs_upstream" {
  name_prefix = "ecs-upstream-"
}
