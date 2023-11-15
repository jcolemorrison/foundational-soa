resource "hcp_vault_cluster" "vault" {
  count             = var.hcp_vault_name != null ? 1 : 0
  cluster_id        = var.hcp_vault_name
  hvn_id            = hcp_hvn.hvn.hvn_id
  public_endpoint   = var.hcp_vault_public_endpoint
  min_vault_version = var.hcp_vault_version
  tier              = var.hcp_vault_tier

  primary_link = var.hcp_vault_primary_link
  paths_filter = var.hcp_vault_paths_filter
}

resource "hcp_vault_cluster_admin_token" "vault" {
  count      = var.hcp_vault_name != null ? 2 : 0
  cluster_id = hcp_vault_cluster.vault.0.cluster_id
}