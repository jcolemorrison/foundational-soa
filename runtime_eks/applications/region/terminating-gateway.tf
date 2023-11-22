data "consul_acl_role" "terminating_gateway" {
  name = "consul-terminating-gateway-acl-role"
}

resource "consul_acl_policy" "terminating_gateway_database" {
  name  = "${var.service_name}-database-write-policy"
  rules = <<-RULE
service "${var.service_name}-database" {
    policy = "write"
}
RULE
}

resource "consul_acl_role_policy_attachment" "terminating_gateway_database" {
  role_id = data.consul_acl_role.terminating_gateway.id
  policy  = consul_acl_policy.terminating_gateway_database.name
}
