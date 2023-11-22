# # Register worker into Boundary after its token is stored in Vault

# data "aws_instances" "boundary_worker" {
#   filter {
#     name   = "instance-id"
#     values = [module.boundary_worker.0.instance_id]
#   }
#   instance_state_names = ["running"]
# }

# data "vault_kv_secret_v2" "boundary_worker_token_eks" {
#   count = length(data.aws_instances.boundary_worker) > 0 ? 1 : 0
#   mount = var.boundary_worker_vault_path
#   name  = "${var.region}-${var.runtime}-${split(".", module.boundary_worker.0.private_dns).0}"
# }

# resource "boundary_worker" "eks" {
#   count                       = length(data.aws_instances.boundary_worker) > 0 ? 1 : 0
#   depends_on                  = [module.boundary_worker, data.vault_kv_secret_v2.boundary_worker_token_eks]
#   scope_id                    = "global"
#   name                        = data.vault_kv_secret_v2.boundary_worker_token_eks.0.name
#   description                 = "Self-managed worker ${data.vault_kv_secret_v2.boundary_worker_token_eks.0.name} for EKS"
#   worker_generated_auth_token = data.vault_kv_secret_v2.boundary_worker_token_eks.0.data.token

#   lifecycle {
#     precondition {
#       condition     = length(data.vault_kv_secret_v2.boundary_worker_token_eks) > 0
#       error_message = "The Boundary EC2 instance has not registered its worker auth token into Vault yet. Wait and re-apply Terraform to register worker."
#     }
#   }
# }