variable "region" {
  type        = string
  description = "Region of service"
}

variable "namespace" {
  type        = string
  description = "Namespace for services"
}

variable "sameness_group_name" {
  type        = string
  description = "Name of sameness group"
  default     = "customers"
}

variable "test_failover_application" {
  type        = bool
  description = "Test failover across regions for application service"
  default     = false
}

variable "test_failover_database" {
  type        = bool
  description = "Test failover across regions for database service"
  default     = false
}

variable "peers_for_failover" {
  type        = list(string)
  description = "Cluster peers for failover"
  default     = []
}

locals {
  service_ports = {
    web         = 9090
    application = 9090
    database    = 9090
  }
}
