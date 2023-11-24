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

  accessible_cidr_blocks            = concat(var.accessible_cidr_blocks, [var.vpc_cidr_block])
  boundary_worker_security_group_id = module.boundary_worker.0.security_group_id
}

locals {
  database_address = var.is_database_primary ? module.database.0.address : module.database.0.read_only_address
}

resource "consul_node" "database" {
  count   = var.create_database ? 1 : 0
  name    = "${var.name}-database"
  address = local.database_address

  meta = {
    "external-node"  = "true"
    "external-probe" = "true"
  }
}

resource "consul_service" "database" {
  count = var.create_database ? 1 : 0
  name  = "${var.name}-database"
  node  = consul_node.database.0.name
  port  = module.database.0.port
  tags  = ["external"]
  meta  = {}

  check {
    check_id = "service:postgres"
    name     = "Postgres health check"
    status   = "passing"
    tcp      = "${local.database_address}:${module.database.0.port}"
    interval = "30s"
    timeout  = "3s"
  }
}

resource "consul_config_entry" "service_defaults" {
  count = var.create_database ? 1 : 0
  name  = "${var.name}-database"
  kind  = "service-defaults"

  config_json = jsonencode({
    Protocol         = "tcp"
    Expose           = {}
    MeshGateway      = {}
    TransparentProxy = {}
  })
}