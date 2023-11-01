output "hvn_id" {
  value       = hcp_hvn.hvn.id
  description = "ID of HashiCorp Virtual Network."
}

## HCP Consul Attributes

output "hcp_consul_id" {
  value       = var.hcp_consul_name != null ? hcp_consul_cluster.consul.0.cluster_id : ""
  description = "ID of HCP Consul."
}

output "hcp_consul_self_link" {
  value       = hcp_consul_cluster.consul.0.self_link
  description = "Self link of HCP Consul."
}

output "hcp_consul_private_endpoint" {
  value       = var.hcp_consul_name != null ? hcp_consul_cluster.consul.0.consul_private_endpoint_url : ""
  description = "Private endpoint of HCP Consul."
}

output "hcp_consul_public_endpoint" {
  value       = var.hcp_consul_name != null && var.hcp_consul_public_endpoint ? hcp_consul_cluster.consul.0.consul_public_endpoint_url : ""
  description = "Public endpoint of HCP Consul."
}

output "hcp_consul_datacenter" {
  value       = var.hcp_consul_name != null ? hcp_consul_cluster.consul.0.datacenter : ""
  description = "Datacenter of HCP Consul Cluster."
}

## HCP Vault Attributes

output "hcp_vault_id" {
  value       = var.hcp_vault_name != null ? hcp_vault_cluster.vault.0.cluster_id : ""
  description = "ID of HCP Vault."
}

output "hcp_vault_self_link" {
  value       = hcp_vault_cluster.vault.0.self_link
  description = "Self link of HCP Vault."
}

output "hcp_vault_private_endpoint" {
  value       = var.hcp_vault_name != null ? hcp_vault_cluster.vault.0.vault_private_endpoint_url : ""
  description = "Private endpoint of HCP Vault."
}

output "hcp_vault_public_endpoint" {
  value       = var.hcp_vault_name != null && var.hcp_vault_public_endpoint ? hcp_vault_cluster.vault.0.vault_public_endpoint_url : ""
  description = "Public endpoint of HCP Vault."
}

output "hcp_vault_namespace" {
  value       = var.hcp_vault_name != null ? hcp_vault_cluster.vault.0.namespace : ""
  description = "Namespce used in HCP Vault."
}

## HCP Boundary Attributes

output "hcp_boundary_id" {
  value       = var.hcp_boundary_name != null ? hcp_boundary_cluster.boundary.0.id : ""
  description = "ID of HCP Boundary."
}

output "hcp_boundary_endpoint" {
  value       = var.hcp_boundary_name != null ? hcp_boundary_cluster.boundary.0.cluster_url : ""
  description = "Public endpoint of HCP Boundary."
}
