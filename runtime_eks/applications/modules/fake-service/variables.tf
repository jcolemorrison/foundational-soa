variable "name" {
  type        = string
  description = "Name of application"
}

variable "runtime" {
  type        = string
  description = "Runtime of application"
  default     = "eks"
}

variable "region" {
  type        = string
  description = "Region of application"
}

variable "namespace" {
  type        = string
  description = "Namespace to deploy application"
  default     = "default"
}

variable "port" {
  type        = string
  description = "Port of application"
}

variable "upstream_uris" {
  type        = string
  description = "Comma-delimited set of upstreams URIs for service to connect"
}

variable "enable_load_balancer" {
  type        = string
  description = "Enable load balancer for service"
  default     = false
}

variable "error_rate" {
  type        = number
  description = "Error rate as a percentage to pass onto the application"
  default     = 0.0
}

variable "error_code" {
  type        = string
  description = "HTTP status code to return on error"
  default     = "500"
}
