resource "tls_private_key" "boundary" {
  algorithm = "RSA"
}

resource "aws_key_pair" "boundary" {
  key_name   = var.name
  public_key = trimspace(tls_private_key.boundary.public_key_openssh)
}

resource "vault_mount" "boundary_worker_ssh" {
  path        = "ssh/${var.region}/${var.runtime}"
  namespace   = var.boundary_worker_vault_namespace
  type        = "kv"
  options     = { version = "2" }
  description = "Boundary worker SSH keys for accessing cluster nodes"
}

resource "vault_kv_secret_v2" "boundary_worker_ssh" {
  mount     = vault_mount.boundary_worker_ssh.path
  namespace = var.boundary_worker_vault_namespace
  name      = "worker-ssh"
  data_json = jsonencode({
    private_key = tls_private_key.boundary.private_key_openssh
  })
}
