# module "boundary_ec2_targets" {
#   source = "../../modules/boundary/hosts"

#   name_prefix = "${replace(var.region, "-", "_")}_${var.runtime}"
#   description = "EC2 instances in ${var.region}"
#   scope_id    = var.boundary_project_scope_id
#   target_ips  = zipmap(data.aws_instances.ec2.ids, data.aws_instances.ec2.private_ips)

#   ingress_worker_filter = "\"${var.runtime}\" in \"/tags/type\" and \"${var.region}\" in \"/tags/type\""
#   egress_worker_filter  = "\"${var.runtime}\" in \"/tags/type\" and \"${var.region}\" in \"/tags/type\""
#   default_port          = 22

#   depends_on = [module.payments, module.reports, data.aws_instances.ec2]
# }

module "boundary_consul_mesh_gateway_targets" {
  source = "../../modules/boundary/hosts"

  name_prefix = "${replace(var.region, "-", "_")}_${var.runtime}_consul_mesh_gateway"
  description = "Consul mesh gateway instances in ${var.region}"
  scope_id    = var.boundary_project_scope_id
  target_ips  = zipmap(data.aws_instances.consul_mesh_gateway.ids, data.aws_instances.consul_mesh_gateway.private_ips)

  ingress_worker_filter = "\"${var.runtime}\" in \"/tags/type\" and \"${var.region}\" in \"/tags/type\""
  egress_worker_filter  = "\"${var.runtime}\" in \"/tags/type\" and \"${var.region}\" in \"/tags/type\""
  default_port          = 22

  depends_on = [module.mesh_gateway, data.aws_instances.consul_mesh_gateway]
}