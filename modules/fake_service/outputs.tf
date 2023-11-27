output "message" {
  value       = "Response from ${var.service} running on ${var.runtime} in ${var.region}"
  description = "Fake-service message to pass to MESSAGE environment variable"
}

output "name" {
  value       = "${var.service}-${var.runtime}-${var.region}"
  description = "Fake-service name to pass to NAME environment variable"
}

output "container_image" {
  value       = var.container_image
  description = "Container image version to use for fake-service"
}
