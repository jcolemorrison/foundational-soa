# test bastion - us-east-1
data "aws_ssm_parameter" "amzn2_us_east_1" {
  # name = "/aws/service/canonical/ubuntu/server/18.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "bastion_us_east_1" {
  ami                    = data.aws_ssm_parameter.amzn2_us_east_1.value
  instance_type          = "t3.micro"
  key_name               = var.keypair_us_east_1
  vpc_security_group_ids = [aws_security_group.bastion_us_east_1.id]
  subnet_id              = module.network_us_east_1.vpc_public_subnet_ids[0]

  associate_public_ip_address = true

  tags = {
    Name = "bastion-us-east-1"
  }
}

resource "aws_security_group" "bastion_us_east_1" {
  name_prefix = "bastion-us-east-1-"
  description = "Firewall for the operator bastion (us-east-1)"
  vpc_id      = module.network_us_east_1.vpc_id
  tags        = { Name = "bastion-us-east-1" }
}

resource "aws_security_group_rule" "bastion_us_east_1_allow_22" {
  security_group_id = aws_security_group.bastion_us_east_1.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow SSH traffic."
}

resource "aws_security_group_rule" "bastion_us_east_1_allow_icmp" {
  security_group_id = aws_security_group.bastion_us_east_1.id
  type              = "ingress"
  protocol          = "icmp"
  from_port         = 8
  to_port           = 0
  cidr_blocks       = [module.network_us_east_1.vpc_cidr_block, module.network_us_west_2.vpc_cidr_block, module.network_eu_west_1.vpc_cidr_block]
  description       = "Allow ICMP traffic."
}

resource "aws_security_group_rule" "bastion_us_east_1_allow_outbound" {
  security_group_id = aws_security_group.bastion_us_east_1.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow any outbound traffic."
}



# test bastion - us-west-2
data "aws_ssm_parameter" "amzn2_us_west_2" {
  # name = "/aws/service/canonical/ubuntu/server/18.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
  provider = aws.us_west_2
}

resource "aws_instance" "bastion_us_west_2" {
  ami                    = data.aws_ssm_parameter.amzn2_us_west_2.value
  instance_type          = "t3.micro"
  key_name               = var.keypair_us_west_2
  vpc_security_group_ids = [aws_security_group.bastion_us_west_2.id]
  subnet_id              = module.network_us_west_2.vpc_public_subnet_ids[0]

  associate_public_ip_address = true

  tags = {
    Name = "bastion-us-west-2"
  }

  provider = aws.us_west_2
}

resource "aws_security_group" "bastion_us_west_2" {
  name_prefix = "bastion-us-west-2-"
  description = "Firewall for the operator bastion (us-west-2)"
  vpc_id      = module.network_us_west_2.vpc_id
  tags        = { Name = "bastion-us-west-2" }

  provider = aws.us_west_2
}

resource "aws_security_group_rule" "bastion_us_west_2_allow_22" {
  security_group_id = aws_security_group.bastion_us_west_2.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow SSH traffic."

  provider = aws.us_west_2
}

resource "aws_security_group_rule" "bastion_us_west_2_allow_icmp" {
  security_group_id = aws_security_group.bastion_us_west_2.id
  type              = "ingress"
  protocol          = "icmp"
  from_port         = 8
  to_port           = 0
  cidr_blocks       = [module.network_us_east_1.vpc_cidr_block, module.network_us_west_2.vpc_cidr_block, module.network_eu_west_1.vpc_cidr_block]
  description       = "Allow ICMP traffic."

  provider = aws.us_west_2
}

resource "aws_security_group_rule" "bastion_us_west_2_allow_outbound" {
  security_group_id = aws_security_group.bastion_us_west_2.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow any outbound traffic."

  provider = aws.us_west_2
}



# test bastion - eu-west-1
data "aws_ssm_parameter" "amzn2_eu_west_1" {
  # name = "/aws/service/canonical/ubuntu/server/18.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
  provider = aws.eu_west_1
}

resource "aws_instance" "bastion_eu_west_1" {
  ami                    = data.aws_ssm_parameter.amzn2_eu_west_1.value
  instance_type          = "t3.micro"
  key_name               = var.keypair_eu_west_1
  vpc_security_group_ids = [aws_security_group.bastion_eu_west_1.id]
  subnet_id              = module.network_eu_west_1.vpc_public_subnet_ids[0]

  associate_public_ip_address = true

  tags = {
    Name = "bastion-eu-west-1"
  }

  provider = aws.eu_west_1
}

resource "aws_security_group" "bastion_eu_west_1" {
  name_prefix = "bastion-eu-west-1-"
  description = "Firewall for the operator bastion (eu-west-1)"
  vpc_id      = module.network_eu_west_1.vpc_id
  tags        = { Name = "bastion-eu-west-1" }

  provider = aws.eu_west_1
}

resource "aws_security_group_rule" "bastion_eu_west_1_allow_22" {
  security_group_id = aws_security_group.bastion_eu_west_1.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow SSH traffic."

  provider = aws.eu_west_1
}

resource "aws_security_group_rule" "bastion_eu_west_1_allow_icmp" {
  security_group_id = aws_security_group.bastion_eu_west_1.id
  type              = "ingress"
  protocol          = "icmp"
  from_port         = 8
  to_port           = 0
  cidr_blocks       = [module.network_us_east_1.vpc_cidr_block, module.network_us_west_2.vpc_cidr_block, module.network_eu_west_1.vpc_cidr_block]
  description       = "Allow ICMP traffic."

  provider = aws.eu_west_1
}

resource "aws_security_group_rule" "bastion_eu_west_1_allow_outbound" {
  security_group_id = aws_security_group.bastion_eu_west_1.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow any outbound traffic."

  provider = aws.eu_west_1
}