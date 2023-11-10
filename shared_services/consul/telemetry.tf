resource "consul_config_entry_service_intentions" "telemetry_us_east_1" {
  name = "consul-telemetry-collector"

  sources {
    name   = "*"
    action = "allow"
  }

  provider = consul.us_east_1
}

resource "consul_config_entry_service_intentions" "telemetry_us_west_2" {
  name = "consul-telemetry-collector"

  sources {
    name   = "*"
    action = "allow"
  }

  provider = consul.us_west_2
}


resource "consul_config_entry_service_intentions" "telemetry_eu_west_1" {
  name = "consul-telemetry-collector"

  sources {
    name   = "*"
    action = "allow"
  }

  provider = consul.eu_west_1
}