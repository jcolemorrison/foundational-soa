resource "consul_config_entry" "mesh_us_east_1" {
  for_each  = toset([for runtime in local.runtimes : runtime])
  name      = "mesh"
  kind      = "mesh"
  partition = each.value

  config_json = jsonencode({
    TransparentProxy = {
      PeerThroughMeshGateways = true
    }
  })

  provider = consul.us_east_1
}

resource "consul_config_entry" "mesh_us_west_2" {
  for_each  = toset([for runtime in local.runtimes : runtime])
  name      = "mesh"
  kind      = "mesh"
  partition = each.value

  config_json = jsonencode({
    TransparentProxy = {
      PeerThroughMeshGateways = true
    }
  })

  provider = consul.us_west_2
}

resource "consul_config_entry" "mesh_eu_west_1" {
  for_each  = toset([for runtime in local.runtimes : runtime])
  name      = "mesh"
  kind      = "mesh"
  partition = each.value

  config_json = jsonencode({
    TransparentProxy = {
      PeerThroughMeshGateways = true
    }
  })

  provider = consul.eu_west_1
}
