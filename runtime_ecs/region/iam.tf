resource "aws_iam_role" "container_instance" {
  name_prefix = "${var.region}-ecs-instance-"
  assume_role_policy = data.aws_iam_policy_document.container_instance_trust_policy.json
}

data "aws_iam_policy_document" "container_instance_trust_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

data "aws_iam_policy_document" "container_instance_permissions_policy" {
  statement {
    sid = "ContainerInstanceECS"
    effect = "Allow"
    actions = [
      "ec2:DescribeTags",
      "ecs:CreateCluster",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:UpdateContainerInstancesState",
      "ecs:Submit*",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
    ]
    resources = ["*"]
  }
  statement {
    sid = "ContainerInstanceLogging"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

## Container Instance Role <> Policy Attachment
resource "aws_iam_role_policy" "container_instance_policy" {
  name_prefix = "${var.region}-ecs-instance-"
  role        = aws_iam_role.container_instance.id
  policy      = data.aws_iam_policy_document.container_instance_permissions_policy.json
}

## Container Instance Profile <> Role Attachment
resource "aws_iam_instance_profile" "container_instance_profile" {
  name_prefix = "${var.region}-ecs-instance-"
  role        = aws_iam_role.container_instance.name
}