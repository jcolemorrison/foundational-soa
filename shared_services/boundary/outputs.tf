output "org_scope_id" {
  value       = boundary_scope.org.id
  description = "Organization scope ID for Boundary"
}

output "org_scope_name" {
  value       = boundary_scope.org.name
  description = "Organization scope name for Boundary"
}

output "runtime_eks_scope_id" {
  value       = boundary_scope.runtime_eks.id
  description = "Runtime EKS scope ID for Boundary"
}

output "runtime_ecs_scope_id" {
  value       = boundary_scope.runtime_ecs.id
  description = "Runtime ECS scope ID for Boundary"
}

output "runtime_ec2_scope_id" {
  value       = boundary_scope.runtime_ec2.id
  description = "Runtime EC2 scope ID for Boundary"
}