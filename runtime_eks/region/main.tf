# Boundary Worker
module "boundary_worker" {
  count  = var.create_boundary_workers ? 1 : 0
  source = "../../modules/boundary_worker"

  name             = "${var.name}-boundary"
  vpc_id           = module.network.vpc_id
  public_subnet_id = module.network.vpc_public_subnet_ids.0

  vault = {
    address   = var.vault_address
    token     = var.boundary_worker_vault_token
    namespace = var.vault_namespace
    path      = var.boundary_worker_vault_path
  }

  boundary_cluster_id = var.boundary_cluster_id
  worker_tags         = [var.name, "ingress"]
  keypair_name        = aws_key_pair.boundary.key_name
}

# EKS
module "eks" {
  count  = var.create_eks_cluster ? 1 : 0
  source = "../modules/eks"

  name = var.name

  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.vpc_private_subnet_ids

  remote_access = {
    ec2_ssh_key               = aws_key_pair.boundary.key_name
    source_security_group_ids = [module.boundary_worker.0.security_group_id]
  }
}