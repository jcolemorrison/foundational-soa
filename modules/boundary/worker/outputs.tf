output "security_group_id" {
  value       = aws_security_group.boundary_worker.id
  description = "Boundary worker security group"
}

output "private_dns" {
  value = aws_instance.worker.private_dns
  description = "Private DNS for Boundary"
}

output "instance_id" {
  value = aws_instance.worker.id
  description = "Instance ID for checking status"
}