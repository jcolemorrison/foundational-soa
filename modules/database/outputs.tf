output "address" {
  value       = aws_rds_cluster.database.endpoint
  description = "Address of database"
}

output "read_only_address" {
  value       = aws_rds_cluster.database.reader_endpoint
  description = "Read-only address for a reader replica"
}

output "port" {
  value       = aws_rds_cluster.database.port
  description = "Port of database"
}

output "username" {
  value       = aws_rds_cluster.database.master_username
  description = "Username of database"
}

output "password" {
  value       = aws_rds_cluster.database.master_password
  description = "Password of database"
  sensitive   = true
}

output "dbname" {
  value       = aws_rds_cluster.database.database_name
  description = "Database name created in managed instance"
}

output "security_group_id" {
  value       = aws_security_group.database.id
  description = "Security group ID for database"
}

output "kms_key_id" {
  value       = aws_rds_cluster.database.kms_key_id
  description = "KMS Key ID for storage encryption"
}
