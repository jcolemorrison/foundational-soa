data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [
    "099720109477"
  ]
}

resource "aws_instance" "worker" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  iam_instance_profile        = aws_iam_instance_profile.boundary_worker.name
  subnet_id                   = var.public_subnet_id
  key_name                    = var.keypair_name
  vpc_security_group_ids      = [aws_security_group.boundary_worker.id]
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/templates/user_data.sh", {
    boundary_cluster_id = var.boundary_cluster_id
    worker_tags         = jsonencode(concat([var.region, var.name, "ingress"], var.worker_tags))
    vault_addr          = var.vault.address
    vault_namespace     = var.vault.namespace
    vault_path          = var.vault.path
    vault_token         = var.vault.token
  })

  tags = local.tags
}
