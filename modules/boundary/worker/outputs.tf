output "security_group_id" {
  value       = aws_security_group.boundary_worker.id
  description = "Boundary worker security group"
}