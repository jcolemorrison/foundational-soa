output "service_access" {
  value       = var.access_map
  description = "Map of service teams access to runtimes"
}

output "list" {
  value       = var.runtimes
  description = "List of runtimes"
}
