output "ip_address" {
  value       = aws_instance.instance.private_ip
  description = "IP address of instance"
}
