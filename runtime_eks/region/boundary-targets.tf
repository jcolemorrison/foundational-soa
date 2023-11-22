# # Register EKS hosts to Boundary project scope
# module "boundary_eks_hosts" {
#   source = "../../modules/boundary/hosts"

#   name_prefix = "${replace(var.region, "-", "_")}_${var.runtime}"
#   description = "EKS nodes in ${var.region}"
#   scope_id    = var.boundary_project_scope_id
#   target_ips  = zipmap(data.aws_instances.eks.ids, data.aws_instances.eks.private_ips)

#   ingress_worker_filter = "\"${var.runtime}\" in \"/tags/type\" and \"${var.region}\" in \"/tags/type\""
#   egress_worker_filter  = "\"${var.runtime}\" in \"/tags/type\" and \"${var.region}\" in \"/tags/type\""
#   default_port          = 22

#   depends_on = [module.eks, data.aws_instances.eks]
# }

# # Register EKS hosts to Boundary project scope
# module "boundary_eks_gateway" {
#   source = "../../modules/boundary/hosts"
#   count  = length(data.aws_lb.consul_api_gateway) > 0 ? 1 : 0

#   name_prefix = "${replace(var.region, "-", "_")}_${var.runtime}_api_gateway"
#   description = "Consul API Gateway on ${var.runtime} cluster in ${var.region}"
#   scope_id    = var.boundary_project_scope_id
#   target_ips  = { for k, v in data.aws_lb.consul_api_gateway : v.name => v.dns_name }

#   ingress_worker_filter = "\"${var.runtime}\" in \"/tags/type\" and \"${var.region}\" in \"/tags/type\""
#   egress_worker_filter  = "\"${var.runtime}\" in \"/tags/type\" and \"${var.region}\" in \"/tags/type\""
#   default_port          = 80

#   depends_on = [module.eks, data.aws_lb.consul_api_gateway]
# }