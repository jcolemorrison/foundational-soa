output "kubernetes_auth_path" {
  description = "Kubernetes authentication paths for each cluster"
  value = {
    us_east_1 = module.vault_auth_us_east_1.path
    us_west_2 = module.vault_auth_us_west_2.path
    eu_west_1 = module.vault_auth_eu_west_1.path
  }
}
