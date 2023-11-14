resource "consul_config_entry" "mesh_us_east_1" {
  name = "mesh"
  kind = "mesh"

  config_json = jsonencode({
    TransparentProxy = {
      PeerThroughMeshGateways = true
    }
  })

  provider = consul.us_east_1
}

resource "consul_config_entry" "mesh_us_west_2" {
  name = "mesh"
  kind = "mesh"

  config_json = jsonencode({
    TransparentProxy = {
      PeerThroughMeshGateways = true
    }
  })

  provider = consul.us_west_2
}

resource "consul_config_entry" "mesh_eu_west_1" {
  name = "mesh"
  kind = "mesh"

  config_json = jsonencode({
    TransparentProxy = {
      PeerThroughMeshGateways = true
    }
  })

  provider = consul.eu_west_1
}