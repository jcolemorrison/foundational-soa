# test bastion - us-east-1
data "aws_ssm_parameter" "amzn2" {
  # name = "/aws/service/canonical/ubuntu/server/18.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ssm_parameter.amzn2.value
  instance_type          = "t3.micro"
  key_name               = var.keypair
  vpc_security_group_ids = [aws_security_group.bastion.id]
  subnet_id              = module.network.vpc_public_subnet_ids[0]

  associate_public_ip_address = true

  tags = {
    Name = "bastion"
  }
}

resource "aws_security_group" "bastion" {
  name_prefix = "bastion-"
  description = "Firewall for the operator bastion (us-east-1)"
  vpc_id      = module.network.vpc_id
  tags        = { Name = "bastion" }
}

resource "aws_security_group_rule" "bastion_allow_22" {
  security_group_id = aws_security_group.bastion.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow SSH traffic."
}

resource "aws_security_group_rule" "bastion_allow_icmp" {
  security_group_id = aws_security_group.bastion.id
  type              = "ingress"
  protocol          = "icmp"
  from_port         = 8
  to_port           = 0
  cidr_blocks       = [module.network.vpc_cidr_block]
  description       = "Allow ICMP traffic."
}

resource "aws_security_group_rule" "bastion_allow_outbound" {
  security_group_id = aws_security_group.bastion.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow any outbound traffic."
}