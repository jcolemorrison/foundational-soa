locals {
  runtime = "ec2"
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

# Register worker into Boundary after its token is stored in Vault

data "aws_instances" "boundary_worker" {
  filter {
    name   = "instance-id"
    values = [module.boundary_worker.0.instance_id]
  }
  instance_state_names = ["running"]
}

data "vault_kv_secret_v2" "boundary_worker_token_ec2" {
  count = length(data.aws_instances.boundary_worker) > 0 ? 1 : 0
  mount = var.boundary_worker_vault_path
  name  = "${var.region}-${local.runtime}-${split(".", module.boundary_worker.0.private_dns).0}"
}

resource "boundary_worker" "ec2" {
  count                       = length(data.aws_instances.boundary_worker) > 0 ? 1 : 0
  depends_on                  = [module.boundary_worker, data.vault_kv_secret_v2.boundary_worker_token_ec2]
  scope_id                    = "global"
  name                        = data.vault_kv_secret_v2.boundary_worker_token_ec2.0.name
  description                 = "Self-managed worker ${data.vault_kv_secret_v2.boundary_worker_token_ec2.0.name} for EC2"
  worker_generated_auth_token = data.vault_kv_secret_v2.boundary_worker_token_ec2.0.data.token
}
