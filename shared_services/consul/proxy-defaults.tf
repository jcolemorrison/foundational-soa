resource "consul_config_entry" "proxy_defaults_us_east_1" {
  kind = "proxy-defaults"
  name = "global"

  config_json = jsonencode({
    MeshGateway = {
      mode = "local"
    }
  })

  provider = consul.us_east_1
}

resource "consul_config_entry" "proxy_defaults_us_west_2" {
  kind = "proxy-defaults"
  name = "global"

  config_json = jsonencode({
    MeshGateway = {
      mode = "local"
    }
  })

  provider = consul.us_west_2
}

resource "consul_config_entry" "proxy_defaults_eu_west_1" {
  kind = "proxy-defaults"
  name = "global"

  config_json = jsonencode({
    MeshGateway = {
      mode = "local"
    }
  })

  provider = consul.eu_west_1
}