resource "consul_admin_partition" "runtime" {
  name        = var.runtime
  description = "Partition for ${var.runtime}"
}