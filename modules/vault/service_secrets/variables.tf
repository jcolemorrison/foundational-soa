variable "service" {
  type        = string
  description = "Name of service"
}

variable "db_name" {
  type        = string
  description = "Name of database to enable database secrets engine"
  default     = null
}

variable "db_username" {
  type        = string
  description = "Database username"
  default     = null
}

variable "db_password" {
  type        = string
  description = "Database password"
  sensitive   = true
  default     = null
}

variable "db_address" {
  type        = string
  description = "Database address"
  default     = null
}

variable "db_port" {
  type        = string
  description = "Database port"
  default     = null
}