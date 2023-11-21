resource "random_pet" "database" {
  length = 1
}

resource "random_password" "database" {
  length           = 16
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  special          = true
  override_special = "*!"
}

locals {
  identifier = "${var.service}-${var.is_primary ? "primary" : "replica"}"
}

resource "aws_rds_cluster" "database" {
  allow_major_version_upgrade = true
  apply_immediately           = true
  cluster_identifier          = local.identifier
  database_name               = var.is_primary ? var.db_name : null
  engine                      = var.database_engine
  engine_version              = var.database_engine_version
  global_cluster_identifier   = var.global_cluster_id
  master_password             = random_password.database.result
  master_username             = random_pet.database.id
  skip_final_snapshot         = true
  db_subnet_group_name        = aws_db_subnet_group.default.name
  vpc_security_group_ids      = [aws_security_group.database.id]

  lifecycle {
    ignore_changes = [engine_version]
  }
}

resource "aws_rds_cluster_instance" "database" {
  engine               = var.database_engine
  engine_version       = var.database_engine_version
  identifier           = "${local.identifier}-instance"
  cluster_identifier   = aws_rds_cluster.database.id
  instance_class       = var.db_instance_class
  db_subnet_group_name = aws_db_subnet_group.default.name
}
