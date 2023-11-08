resource "aws_iam_role" "boundary_worker" {
  name_prefix = "${var.name}-"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = local.tags
}

resource "aws_iam_instance_profile" "boundary_worker" {
  name_prefix = "${var.name}-"
  role        = aws_iam_role.boundary_worker.name
}
