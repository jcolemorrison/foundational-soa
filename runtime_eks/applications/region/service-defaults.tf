resource "consul_config_entry" "service_defaults_inventory" {
  for_each  = toset(local.consul_partitions)
  name      = "inventory"
  kind      = "service-defaults"
  partition = each.value

  config_json = jsonencode({
    Protocol = "http"
  })
}

resource "consul_config_entry" "service_defaults_inventory_v2" {
  for_each  = toset(local.consul_partitions)
  name      = "inventory-v2"
  kind      = "service-defaults"
  partition = each.value

  config_json = jsonencode({
    Protocol = "http"
  })
}
