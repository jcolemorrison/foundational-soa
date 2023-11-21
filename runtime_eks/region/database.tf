module "database" {
  count                  = var.create_database ? 1 : 0
  source                 = "../../modules/database"
  db_name                = var.db_name
  service                = var.name
  vpc_id                 = module.network.vpc_id
  private_subnet_ids     = module.network.vpc_private_subnet_ids
  hcp_network_cidr_block = var.hcp_hvn_cidr_block

  database_engine         = var.database_engine
  database_engine_version = var.database_engine_version
  global_cluster_id       = var.global_cluster_id
  is_primary              = var.is_database_primary

  accessible_cidr_blocks = var.accessible_cidr_blocks
}
