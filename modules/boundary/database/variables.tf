variable "db_name" {
  type        = string
  description = "Database name"
}

variable "service" {
  type        = string
  description = "Name of service to identify instance"
}

variable "ingress_worker_filter" {
  type        = string
  description = "Target ingress worker filter for Boundary."
}

variable "egress_worker_filter" {
  type        = string
  description = "Target egress worker filter for Boundary."
}

variable "db_host" {
  type        = string
  description = "Database host"
}

variable "db_port" {
  type        = number
  description = "Database port"
}

variable "boundary_scope_id" {
  type        = string
  description = "ID of Boudnary scope to add database connnection"
}

variable "boundary_credentials_store_id" {
  type        = string
  description = "Credentials store ID for Boundary scope"
}

variable "vault_path_to_database_credentials" {
  type        = string
  description = "Path in Vault to database credentials."
}

variable "access_level" {
  type        = string
  default     = "read"
  description = "Describe access to target, must be write or read"
  validation {
    condition     = contains(["write", "read"], var.access_level)
    error_message = "Access level can only be write or read"
  }
}
