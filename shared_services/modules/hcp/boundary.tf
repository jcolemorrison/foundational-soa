resource "random_pet" "boundary" {
  count  = var.hcp_boundary_name != null ? 1 : 0
  length = 2
}

resource "random_password" "boundary" {
  count       = var.hcp_boundary_name != null ? 1 : 0
  length      = 16
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  min_special = 1
}

resource "hcp_boundary_cluster" "boundary" {
  count      = var.hcp_boundary_name != null ? 1 : 0
  cluster_id = var.hcp_boundary_name
  username   = random_pet.boundary.0.id
  password   = random_password.boundary.0.result
  tier       = var.hcp_boundary_tier
}