# EKS

module "eks" {
  count   = var.cluster_name != null ? 1 : 0
  source  = "terraform-aws-modules/eks/aws"
  version = "19.16.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.28"

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.vpc_private_subnet_ids

  eks_managed_node_group_defaults = {
    create_iam_role = true
    ami_type        = "AL2_x86_64"
    disk_size       = 100
    instance_types  = ["m5.large"]
  }

  eks_managed_node_groups = {
    hashicups = {
      use_custom_launch_template = false

      min_size     = 1
      max_size     = 5
      desired_size = 3

      instance_types = ["m5.large"]
    }
  }
}