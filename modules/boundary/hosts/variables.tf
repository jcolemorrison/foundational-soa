variable "scope_id" {
  type        = string
  description = "Scope ID for Boundary host catalog"
}

variable "name_prefix" {
  type        = string
  description = "Name prefix for Boundary host catalog."
}

variable "target_ips" {
  type        = map(string)
  description = "Map of instance ID and IP address of hosts to register"
}

variable "description" {
  type        = string
  description = "Description for host catalog and host sets."
}

variable "target_type" {
  type        = string
  description = "Target type for Boundary."
  default     = "tcp"
}

variable "ingress_worker_filter" {
  type        = string
  description = "Target ingress worker filter for Boundary."
}

variable "egress_worker_filter" {
  type        = string
  description = "Target egress worker filter for Boundary."
}

variable "session_connection_limit" {
  type        = number
  description = "Target session connection limit."
  default     = -1
}

variable "default_port" {
  type        = number
  description = "Target default port."
}