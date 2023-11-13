resource "consul_config_entry" "telemetry_us_east_1" {
  name = "consul-telemetry-collector"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = "*"
        Precedence = 8
        Type       = "consul"
        Namespace  = "default"
        Partition  = "default"
      }
    ]
  })

  provider = consul.us_east_1
}

resource "consul_config_entry" "telemetry_us_west_2" {
  name = "consul-telemetry-collector"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = "*"
        Precedence = 8
        Type       = "consul"
        Namespace  = "default"
        Partition  = "default"
      }
    ]
  })

  provider = consul.us_west_2
}

resource "consul_config_entry" "telemetry_eu_west_1" {
  name = "consul-telemetry-collector"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = "*"
        Precedence = 8
        Type       = "consul"
        Namespace  = "default"
        Partition  = "default"
      }
    ]
  })

  provider = consul.eu_west_1
}