data "consul_acl_role" "terminating_gateway" {
  name = "consul-terminating-gateway-acl-role"
}

resource "consul_acl_policy" "terminating_gateway_database" {
  name  = "${var.service}-database-write-policy"
  rules = <<-RULE
service "${var.service}-database" {
    policy = "write"
}
RULE
}
