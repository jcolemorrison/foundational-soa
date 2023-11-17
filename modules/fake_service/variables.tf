variable "service" {
  type        = string
  description = "Name of service"
}

variable "runtime" {
  type        = string
  description = "Runtime of application"
}

variable "region" {
  type        = string
  description = "Region of application"
}

variable "container_image" {
  type        = string
  description = "Default container image version"
  default     = "nicholasjackson/fake-service:v0.26.0"
}