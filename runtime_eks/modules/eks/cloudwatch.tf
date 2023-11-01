resource "aws_cloudwatch_log_group" "cluster" {
  name              = "${var.path_prefix}/${var.name}/cluster"
  retention_in_days = 3

  tags = merge(
    local.tags,
    { Name = "${var.path_prefix}/${var.name}/cluster" }
  )
}

