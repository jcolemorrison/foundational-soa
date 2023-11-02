# EKS

module "eks" {
  count  = var.cluster_name != null ? 1 : 0
  source = "../modules/eks"

  name = var.cluster_name

  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.vpc_private_subnet_ids

  remote_access = {
    ec2_ssh_key               = var.keypair
    source_security_group_ids = [aws_security_group.bastion.id]
  }
}

# module "eks_v2" {
#   count   = var.cluster_name != null ? 1 : 0
#   source  = "terraform-aws-modules/eks/aws"
#   version = "19.16.0"

#   cluster_name = "${var.cluster_name}-v2"

#   cluster_endpoint_public_access  = true
#   cluster_endpoint_private_access = true

#   vpc_id     = module.network.vpc_id
#   subnet_ids = module.network.vpc_private_subnet_ids
#   iam_role_path = "/aws/eks/${var.cluster_name}-v2"

#   eks_managed_node_group_defaults = {
#     create_iam_role = true
#     ami_type        = "AL2_x86_64"
#     disk_size       = 100
#   }

#   eks_managed_node_groups = {
#     hashicups = {
#       use_custom_launch_template = false

#       min_size     = 1
#       max_size     = 5
#       desired_size = 3
#     }
#   }
# }

