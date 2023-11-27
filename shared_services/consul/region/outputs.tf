output "partition_name" {
  value       = consul_admin_partition.runtime.name
  description = "Consul admin partition"
}