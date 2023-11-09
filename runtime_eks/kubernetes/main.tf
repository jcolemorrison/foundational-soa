module "us_east_1" {
  source = "./region"

  hcp_consul_cluster_id     = local.us_east_1.consul.id
  hcp_vault_private_address = local.us_east_1.vault.private_address
  kubernetes_endpoint       = replace(data.aws_eks_cluster.us_east_1.endpoint, "https://", "")

  providers = {
    aws        = aws
    kubernetes = kubernetes.us_east_1
    helm       = helm.us_east_1
  }
}