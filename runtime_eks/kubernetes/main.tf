module "us_east_1" {
  source = "./region"

  hcp_consul_cluster_id     = local.us_east_1.consul.id
  hcp_vault_private_address = local.us_east_1.vault.private_address
  kubernetes_endpoint       = replace(data.aws_eks_cluster.us_east_1.endpoint, "https://", "")

  hcp_consul_observability = {
    client_id     = var.hcp_consul_observability.us_east_1.client_id
    client_secret = var.hcp_consul_observability.us_east_1.client_secret
    resource_id   = var.hcp_consul_observability.us_east_1.resource_id
  }

  consul_token = local.us_east_1.consul.token

  cluster_name                      = local.cluster_name
  aws_lb_controller_namespace       = local.aws_irsa.us_east_1.namespace
  aws_lb_controller_service_account = local.aws_irsa.us_east_1.service_account
  aws_lb_controller_irsa_role_arn   = local.aws_irsa.us_east_1.role_arn

  providers = {
    aws        = aws
    kubernetes = kubernetes.us_east_1
    helm       = helm.us_east_1
    vault      = vault.us_east_1
  }
}

module "us_west_2" {
  source = "./region"

  hcp_consul_cluster_id     = local.us_west_2.consul.id
  hcp_vault_private_address = local.us_west_2.vault.private_address
  kubernetes_endpoint       = replace(data.aws_eks_cluster.us_west_2.endpoint, "https://", "")

  hcp_consul_observability = {
    client_id     = var.hcp_consul_observability.us_west_2.client_id
    client_secret = var.hcp_consul_observability.us_west_2.client_secret
    resource_id   = var.hcp_consul_observability.us_west_2.resource_id
  }

  consul_token = local.us_west_2.consul.token

  cluster_name                      = local.cluster_name
  aws_lb_controller_namespace       = local.aws_irsa.us_west_2.namespace
  aws_lb_controller_service_account = local.aws_irsa.us_west_2.service_account
  aws_lb_controller_irsa_role_arn   = local.aws_irsa.us_west_2.role_arn

  providers = {
    aws        = aws.us_west_2
    kubernetes = kubernetes.us_west_2
    helm       = helm.us_west_2
    vault      = vault.us_west_2
  }
}

module "eu_west_1" {
  source = "./region"

  hcp_consul_cluster_id     = local.eu_west_1.consul.id
  hcp_vault_private_address = local.eu_west_1.vault.private_address
  kubernetes_endpoint       = replace(data.aws_eks_cluster.eu_west_1.endpoint, "https://", "")

  hcp_consul_observability = {
    client_id     = var.hcp_consul_observability.eu_west_1.client_id
    client_secret = var.hcp_consul_observability.eu_west_1.client_secret
    resource_id   = var.hcp_consul_observability.eu_west_1.resource_id
  }

  consul_token = local.eu_west_1.consul.token

  cluster_name                      = local.cluster_name
  aws_lb_controller_namespace       = local.aws_irsa.eu_west_1.namespace
  aws_lb_controller_service_account = local.aws_irsa.eu_west_1.service_account
  aws_lb_controller_irsa_role_arn   = local.aws_irsa.eu_west_1.role_arn

  providers = {
    aws        = aws.eu_west_1
    kubernetes = kubernetes.eu_west_1
    helm       = helm.eu_west_1
    vault      = vault.eu_west_1
  }
}
