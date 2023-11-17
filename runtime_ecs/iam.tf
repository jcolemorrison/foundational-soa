## Role and Policies for Container (EC2) Instances

resource "aws_iam_role" "container_instance" {
  name_prefix = "ecs-instance-"
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
  name_prefix = "ecs-instance-"
  role        = aws_iam_role.container_instance.id
  policy      = data.aws_iam_policy_document.container_instance_permissions_policy.json
}

## Container Instance Profile <> Role Attachment
resource "aws_iam_instance_profile" "container_instance_profile" {
  name_prefix = "ecs-instance-"
  role        = aws_iam_role.container_instance.name
}

## Role Policy for Consul ECS Mesh Tasks

resource "aws_iam_policy" "execute_command" {
  name_prefix = "ecs-execute-command"
  policy = data.aws_iam_policy_document.execute_command_permissions_policy.json
}

data "aws_iam_policy_document" "execute_command_permissions_policy" {
  statement {
    sid = "ExecuteCommandConsulModule"
    effect = "Allow"
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }
}

## Role for ECS Services

resource "aws_iam_role" "ecs_service" {
  name_prefix = "ecs-service-"
  assume_role_policy = data.aws_iam_policy_document.container_instance_trust_policy.json
}

data "aws_iam_policy_document" "ecs_service_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type = "Service"
      identifiers = ["ecs.amazonaws.com",]
    }
  }
}

resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name   = "ecs-service-role-policy"
  policy = data.aws_iam_policy_document.ecs_service_role_policy.json
  role   = aws_iam_role.ecs_service.id
}

data "aws_iam_policy_document" "ecs_service_role_policy" {
  statement {
    sid = "ECSTaskManagement"
    effect  = "Allow"
    actions = [
      "ec2:AttachNetworkInterface",
      "ec2:CreateNetworkInterface",
      "ec2:CreateNetworkInterfacePermission",
      "ec2:DeleteNetworkInterface",
      "ec2:DeleteNetworkInterfacePermission",
      "ec2:Describe*",
      "ec2:DetachNetworkInterface",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets",
      "route53:ChangeResourceRecordSets",
      "route53:CreateHealthCheck",
      "route53:DeleteHealthCheck",
      "route53:Get*",
      "route53:List*",
      "route53:UpdateHealthCheck",
      "servicediscovery:DeregisterInstance",
      "servicediscovery:Get*",
      "servicediscovery:List*",
      "servicediscovery:RegisterInstance",
      "servicediscovery:UpdateInstanceCustomHealthStatus"
    ]
    resources = ["*"]
  }

  statement {
    sid = "AutoScaling"
    effect  = "Allow"
    actions = [
      "autoscaling:Describe*"
    ]
    resources = ["*"]
  }

  statement {
    sid = "AutoScalingManagement"
    effect  = "Allow"
    actions = [
      "autoscaling:DeletePolicy",
      "autoscaling:PutScalingPolicy",
      "autoscaling:SetInstanceProtection",
      "autoscaling:UpdateAutoScalingGroup"
    ]
    resources = ["*"]
    condition {
      test = "Null"
      variable = "autoscaling:ResourceTag/AmazonECSManaged"
      values = ["false"]
    }
  }

  statement {
    sid = "AutoScalingPlanManagement"
    effect  = "Allow"
    actions = [
      "autoscaling-plans:CreateScalingPlan",
      "autoscaling-plans:DeleteScalingPlan",
      "autoscaling-plans:DescribeScalingPlans"
    ]
    resources = ["*"]
  }

  statement {
    sid = "CWAlarmManagement"
    effect  = "Allow"
    actions = [
      "cloudwatch:DeleteAlarms",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:PutMetricAlarm"
    ]
    resources = ["arn:aws:cloudwatch:*:*:alarm:*"]
  }

  statement {
    sid = "ECSTagging"
    effect  = "Allow"
    actions = [
      "ec2:CreateTags"
    ]
    resources = ["arn:aws:ec2:*:*:network-interface/*"]
  }

  statement {
    sid = "CWLogGroupManagement"
    effect  = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:DescribeLogGroups",
      "logs:PutRetentionPolicy"
    ]
    resources = ["arn:aws:logs:*:*:log-group:/aws/ecs/*"]
  }

  statement {
    sid = "CWLogStreamManagement"
    effect  = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:log-group:/aws/ecs/*:log-stream:*"]
  }

  statement {
    sid = "ExecuteCommandSessionManagement"
    effect  = "Allow"
    actions = [
      "ssm:DescribeSessions"
    ]
    resources = ["*"]
  }

  statement {
    sid = "ExecuteCommand"
    effect  = "Allow"
    actions = [
      "ssm:StartSession"
    ]
    resources = [
      "arn:aws:ecs:*:*:task/*",
      "arn:aws:ssm:*:*:document/AmazonECS-ExecuteInteractiveCommand"
    ]
  }

  statement {
    sid = "CloudMapResourceCreation"
    effect  = "Allow"
    actions = [
      "servicediscovery:CreateHttpNamespace",
      "servicediscovery:CreateService"
    ]
    resources = ["*"]
    condition {
      test = "ForAllValues:StringEquals"
      variable = "aws:TagKeys"
      values = ["AmazonECSManaged"]
    }
  }

  statement {
    sid = "CloudMapResourceTagging"
    effect  = "Allow"
    actions = [
      "servicediscovery:TagResource"
    ]
    resources = ["*"]
    condition {
      test = "StringLike"
      variable = "aws:RequestTag/AmazonECSManaged"
      values = ["*"]
    }
  }

  statement {
    sid = "CloudMapResourceDeletion"
    effect  = "Allow"
    actions = [
      "servicediscovery:DeleteService"
    ]
    resources = ["*"]
    condition {
      test = "Null"
      variable = "aws:ResourceTag/AmazonECSManaged"
      values = ["*"]
    }
  }

  statement {
    sid = "CloudMapResourceDiscovery"
    effect  = "Allow"
    actions = [
      "servicediscovery:DiscoverInstances",
			"servicediscovery:DiscoverInstancesRevision"
    ]
    resources = ["*"]
  }
}