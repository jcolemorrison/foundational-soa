locals {
  runtime = "eks"
}

# Boundary Worker
module "boundary_worker" {
  count  = var.create_boundary_workers ? 1 : 0
  source = "../../modules/boundary/worker"

  name             = "${var.name}-boundary"
  region           = var.region
  vpc_id           = module.network.vpc_id
  public_subnet_id = module.network.vpc_public_subnet_ids.0

  vault = {
    address   = var.vault_address
    token     = var.boundary_worker_vault_token
    namespace = var.vault_namespace
    path      = var.boundary_worker_vault_path
  }

  boundary_cluster_id = var.boundary_cluster_id
  keypair_name        = aws_key_pair.boundary.key_name
  runtime             = local.runtime
}

# EKS
module "eks" {
  count  = var.create_eks_cluster ? 1 : 0
  source = "../modules/eks"

  name = var.name

  vpc_id                 = module.network.vpc_id
  private_subnet_ids     = module.network.vpc_private_subnet_ids
  hcp_network_cidr_block = var.hcp_hvn_cidr_block
  accessible_cidr_blocks = var.accessible_cidr_blocks

  remote_access = {
    ec2_ssh_key               = aws_key_pair.boundary.key_name
    source_security_group_ids = [module.boundary_worker.0.security_group_id]
  }
}

# Register EKS hosts to Boundary project scope
module "boundary_eks_hosts" {
  source = "../../modules/boundary/hosts"

  name_prefix = "${replace(var.region, "-", "_")}_eks"
  description = "EKS nodes in ${var.region}"
  scope_id    = var.boundary_project_scope_id
  target_ips  = zipmap(data.aws_instances.eks.ids, data.aws_instances.eks.private_ips)

  ingress_worker_filter = "\"${local.runtime}\" in \"/tags/type\" and \"${var.region}\" in \"/tags/type\""
  egress_worker_filter  = "\"${local.runtime}\" in \"/tags/type\" and \"${var.region}\" in \"/tags/type\""
  default_port          = 22

  depends_on = [module.eks, data.aws_instances.eks]
}

data "aws_lbs" "consul_api_gateway" {
  tags = {
    "elbv2.k8s.aws/cluster" = var.name
    "service.k8s.aws/stack" = "consul/api-gateway"
  }
}

data "aws_lb" "consul_api_gateway" {
  for_each = toset(data.aws_lbs.consul_api_gateway.arns)
  arn      = each.value
}

# Register EKS hosts to Boundary project scope
module "boundary_eks_gateway" {
  source = "../../modules/boundary/hosts"
  count  = length(data.aws_lb.consul_api_gateway) > 0 ? 1 : 0

  name_prefix = "${replace(var.region, "-", "_")}_eks_api_gateway"
  description = "Consul API Gateway on EKS cluster in ${var.region}"
  scope_id    = var.boundary_project_scope_id
  target_ips  = { for k, v in data.aws_lb.consul_api_gateway : v.name => v.dns_name }

  ingress_worker_filter = "\"${local.runtime}\" in \"/tags/type\" and \"${var.region}\" in \"/tags/type\""
  egress_worker_filter  = "\"${local.runtime}\" in \"/tags/type\" and \"${var.region}\" in \"/tags/type\""
  default_port          = 80

  depends_on = [module.eks, data.aws_lb.consul_api_gateway]
}

# Register worker into Boundary after its token is stored in Vault

data "aws_instances" "boundary_worker" {
  filter {
    name   = "instance-id"
    values = [module.boundary_worker.0.instance_id]
  }
  instance_state_names = ["running"]
}

data "vault_kv_secret_v2" "boundary_worker_token_eks" {
  count = length(data.aws_instances.boundary_worker) > 0 ? 1 : 0
  mount = var.boundary_worker_vault_path
  name  = "${var.region}-${local.runtime}-${split(".", module.boundary_worker.0.private_dns).0}"
}

resource "boundary_worker" "eks" {
  count                       = length(data.aws_instances.boundary_worker) > 0 ? 1 : 0
  depends_on                  = [module.boundary_worker, data.vault_kv_secret_v2.boundary_worker_token_eks]
  scope_id                    = "global"
  name                        = data.vault_kv_secret_v2.boundary_worker_token_eks.0.name
  description                 = "Self-managed worker ${data.vault_kv_secret_v2.boundary_worker_token_eks.0.name} for EKS"
  worker_generated_auth_token = data.vault_kv_secret_v2.boundary_worker_token_eks.0.data.token

  lifecycle {
    precondition {
      condition     = length(data.vault_kv_secret_v2.boundary_worker_token_eks) > 0
      error_message = "The Boundary EC2 instance has not registered its worker auth token into Vault yet. Wait and re-apply Terraform to register worker."
    }
  }
}
