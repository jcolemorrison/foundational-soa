# Boundary Worker
module "boundary_worker" {
  count  = var.cluster_name != null ? 1 : 0
  source = "../../modules/boundary_worker"

  name   = "${var.cluster_name}-boundary"
  vpc_id = module.network.vpc_id
}

# EKS
module "eks" {
  count  = var.cluster_name != null ? 1 : 0
  source = "../modules/eks"

  name = var.cluster_name

  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.vpc_private_subnet_ids

  remote_access = {
    ec2_ssh_key               = module.boundary_worker.0.keypair_name
    source_security_group_ids = [module.boundary_worker.0.security_group_id]
  }
}