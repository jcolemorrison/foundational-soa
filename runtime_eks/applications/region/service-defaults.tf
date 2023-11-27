resource "consul_config_entry" "service_defaults_inventory_ec2" {
  name      = "inventory"
  kind      = "service-defaults"
  partition = "ec2"

  config_json = jsonencode({
    Protocol = "http"
  })
}

resource "consul_config_entry" "service_defaults_inventory_ecs" {
  name      = "inventory"
  kind      = "service-defaults"
  partition = "ecs"

  config_json = jsonencode({
    Protocol = "http"
  })
}

resource "consul_config_entry" "service_defaults_inventory_v2_ec2" {
  name      = "inventory"
  kind      = "service-defaults"
  partition = "ec2"

  config_json = jsonencode({
    Protocol = "http"
  })
}

resource "consul_config_entry" "service_defaults_inventory_v2_ecs" {
  name      = "inventory"
  kind      = "service-defaults"
  partition = "ecs"

  config_json = jsonencode({
    Protocol = "http"
  })
}