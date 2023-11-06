resource "aws_cloudwatch_log_group" "cluster" {
  name              = "${var.path_prefix}/${var.name}/cluster"
  retention_in_days = 3
  skip_destroy      = false

  tags = merge(
    local.tags,
    { Name = "${var.name}-eks-logs" }
  )
}

