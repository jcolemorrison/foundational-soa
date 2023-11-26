data "consul_acl_role" "mesh_gateway" {
  name = "consul-mesh-gateway-acl-role"
}

resource "consul_acl_policy" "mesh_gateway_partitions" {
  name  = "${var.service_name}-mesh-gateway-cross-partitions"
  rules = <<-RULE
operator = "write"
agent_prefix "" {
  policy = "read"
}
partition_prefix "" {
  namespace_prefix "" {
    acl = "write"
    service_prefix "" {
      policy = "write"
    }
  }
}
RULE
}

resource "consul_acl_role_policy_attachment" "mesh_gateway_partitions" {
  role_id = data.consul_acl_role.mesh_gateway.id
  policy  = consul_acl_policy.mesh_gateway_partitions.name
}

