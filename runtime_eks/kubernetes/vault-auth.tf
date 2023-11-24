module "vault_auth_us_east_1" {
  source = "./modules/vault_auth"

  region              = "us_east_1"
  kubernetes_endpoint = data.aws_eks_cluster.us_east_1.endpoint
  kubernetes_ca_cert  = module.us_east_1.kubernetes_ca_cert
  kubernetes_token    = module.us_east_1.kubernetes_token

  providers = {
    vault = vault.us_east_1
  }
}

module "vault_auth_us_west_2" {
  source = "./modules/vault_auth"

  region              = "us_west_2"
  kubernetes_endpoint = data.aws_eks_cluster.us_west_2.endpoint
  kubernetes_ca_cert  = module.us_west_2.kubernetes_ca_cert
  kubernetes_token    = module.us_west_2.kubernetes_token

  providers = {
    vault = vault.us_east_1
  }
}

module "vault_auth_eu_west_1" {
  source = "./modules/vault_auth"

  region              = "eu_west_1"
  kubernetes_endpoint = data.aws_eks_cluster.eu_west_1.endpoint
  kubernetes_ca_cert  = module.eu_west_1.kubernetes_ca_cert
  kubernetes_token    = module.eu_west_1.kubernetes_token

  providers = {
    vault = vault.us_east_1
  }
}
