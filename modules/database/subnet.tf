resource "aws_db_subnet_group" "default" {
  name_prefix = "${var.service}-"
  subnet_ids  = var.private_subnet_ids

  tags = {
    Name = var.service
  }
}

resource "aws_security_group" "database" {
  name        = "${var.service}-database"
  description = "Allow inbound traffic to ${var.service} database"
  vpc_id      = var.vpc_id

  tags = {
    Name    = "${var.service}-database"
    Purpose = "database"
  }
}

resource "aws_security_group_rule" "allow_database_from_vpc" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = concat([var.hcp_network_cidr_block], var.accessible_cidr_blocks)
  security_group_id = aws_security_group.database.id
}

resource "aws_security_group_rule" "allow_database_from_boundary_worker" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = var.boundary_worker_security_group_id
  security_group_id        = aws_security_group.database.id
}

resource "aws_security_group_rule" "allow_database_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.database.id
}
