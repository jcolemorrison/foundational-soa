resource "consul_config_entry" "proxy_defaults_us_east_1" {
  for_each  = toset([for runtime in local.runtimes : runtime])
  kind      = "proxy-defaults"
  name      = "global"
  partition = each.value

  config_json = jsonencode({
    AccessLogs = {
      Enabled = true
    }
    Expose = {}
    MeshGateway = {
      Mode = "local"
    }
    TransparentProxy = {}
  })

  provider = consul.us_east_1
}

resource "consul_config_entry" "proxy_defaults_us_west_2" {
  for_each  = toset([for runtime in local.runtimes : runtime])
  kind      = "proxy-defaults"
  name      = "global"
  partition = each.value

  config_json = jsonencode({
    AccessLogs = {
      Enabled = true
    }
    Expose = {}
    MeshGateway = {
      Mode = "local"
    }
    TransparentProxy = {}
  })

  provider = consul.us_west_2
}

resource "consul_config_entry" "proxy_defaults_eu_west_1" {
  for_each  = toset([for runtime in local.runtimes : runtime])
  kind      = "proxy-defaults"
  name      = "global"
  partition = each.value

  config_json = jsonencode({
    AccessLogs = {
      Enabled = true
    }
    Expose = {}
    MeshGateway = {
      Mode = "local"
    }
    TransparentProxy = {}
  })

  provider = consul.eu_west_1
}

