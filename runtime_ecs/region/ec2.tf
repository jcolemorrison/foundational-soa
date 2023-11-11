data "aws_ssm_parameter" "ecs_optimized_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2023/recommended"
}

resource "aws_launch_template" "container_instance" {
  description = "launch template for ECS container instances"
  iam_instance_profile {
    arn = aws_iam_instance_profile.container_instance_profile.arn
  }
  image_id = data.aws_ssm_parameter.ecs_optimized_ami.value
  instance_type = var.instance_type
  key_name = var.ecs_keypair
  name_prefix = "${var_region}-ecs-instance-"
  user_data = base64encode(templatefile("${path.module}/scripts/container_instance.sh", {
  }))
  # vpc_security_group_ids = [ "" ]
}

resource "aws_security_group" "container_instance" {
  name_prefix = "${var.region}-ecs-instance-"
}