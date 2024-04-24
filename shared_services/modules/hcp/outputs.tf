output "hvn_id" {
  value       = hcp_hvn.hvn.id
  description = "ID of HashiCorp Virtual Network."
}

output "hvn_cidr_block" {
  value       = hcp_hvn.hvn.cidr_block
  description = "CIDR block of HashiCorp Virtual Network."
}

output "hvn_self_link" {
  value       = hcp_hvn.hvn.self_link
  description = "Self link of HashiCorp Virtual Network for peering."
}

## HCP Consul Attributes

output "hcp_consul" {
  value = {
    id              = var.hcp_consul_name != null ? hcp_consul_cluster.consul.0.cluster_id : ""
    self_link       = var.hcp_consul_name != null ? hcp_consul_cluster.consul.0.self_link : ""
    datacenter      = var.hcp_consul_name != null ? hcp_consul_cluster.consul.0.datacenter : ""
    address         = var.hcp_consul_name != null && var.hcp_consul_public_endpoint ? hcp_consul_cluster.consul.0.consul_public_endpoint_url : ""
    private_address = var.hcp_consul_name != null ? hcp_consul_cluster.consul.0.consul_private_endpoint_url : ""
    token           = var.hcp_consul_name != null ? hcp_consul_cluster.consul.0.consul_root_token_secret_id : ""
    retry_join      = var.hcp_consul_name != null ? jsondecode(base64decode(hcp_consul_cluster.consul.0.consul_config_file))["retry_join"][0] : ""
  }
  description = "HCP Consul cluster details"
  sensitive   = true
}

## HCP Vault Attributes

output "hcp_vault" {
  value = {
    id              = var.hcp_vault_name != null ? hcp_vault_cluster.vault.0.cluster_id : ""
    self_link       = var.hcp_vault_name != null ? hcp_vault_cluster.vault.0.self_link : ""
    namespace       = var.hcp_vault_name != null ? hcp_vault_cluster.vault.0.namespace : ""
    address         = var.hcp_vault_name != null && var.hcp_vault_public_endpoint ? hcp_vault_cluster.vault.0.vault_public_endpoint_url : ""
    private_address = var.hcp_vault_name != null ? hcp_vault_cluster.vault.0.vault_private_endpoint_url : ""
    # token           = var.hcp_vault_name != null ? hcp_vault_cluster_admin_token.vault.0.token : ""
  }
  description = "HCP Vault cluster details"
  sensitive   = true
}

## HCP Boundary Attributes

output "hcp_boundary" {
  value = {
    id       = var.hcp_boundary_name != null ? hcp_boundary_cluster.boundary.0.id : ""
    address  = var.hcp_boundary_name != null ? hcp_boundary_cluster.boundary.0.cluster_url : ""
    username = var.hcp_boundary_name != null ? hcp_boundary_cluster.boundary.0.username : ""
    password = var.hcp_boundary_name != null ? hcp_boundary_cluster.boundary.0.password : ""
  }
  description = "HCP Boundary cluster details"
  sensitive   = true
}