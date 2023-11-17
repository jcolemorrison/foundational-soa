output "message" {
  value = "Response from ${var.service} running on ${var.runtime} in ${var.region}"
}

output "name" {
  value = "${var.service}-${var.runtime}-${var.region}"
}

output "container_image" {
  value = var.container_image
}