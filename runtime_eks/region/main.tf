# EKS

module "eks" {
  count  = var.cluster_name != null ? 1 : 0
  source = "../modules/eks"

  name = var.cluster_name

  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.vpc_private_subnet_ids
}
