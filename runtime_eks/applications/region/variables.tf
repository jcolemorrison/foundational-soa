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

variable "service_name" {
  type        = string
  description = "Service name for gateway"
}

variable "database_port" {
  type        = number
  description = "Port for database service"
  default     = 5432
}

variable "vault_namespace" {
  type        = string
  description = "Vault namespace for database credentials"
}

variable "vault_database_path" {
  type        = string
  description = "Vault database path to allow application to access database credentials"
}

variable "vault_database_secret_role" {
  type        = string
  description = "Vault database secret role to allow application to access database credentials"
}

variable "vault_kubernetes_auth_path" {
  type        = string
  description = "Vault Kubernetes authentication method path"
  default     = "kubernetes"
}

locals {
  service_ports = {
    web         = 9090
    application = 9090
    database    = 9090
  }
}
