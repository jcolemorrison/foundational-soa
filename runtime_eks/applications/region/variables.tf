variable "region" {
  type        = string
  description = "Region of service"
}

variable "namespace" {
  type        = string
  description = "Namespace for services"
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

variable "peer_for_application_failover" {
  type        = string
  description = "Cluster peer for application failover"
  default     = ""
}

variable "peer_for_database_failover" {
  type        = string
  description = "Cluster peer for database failover"
  default     = ""
}

locals {
  service_ports = {
    web         = 9090
    application = 9090
    database    = 9090
  }
}
