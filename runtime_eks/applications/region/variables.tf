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
  default     = "common"
}

variable "test_failover_customers" {
  type        = bool
  description = "Test failover across regions for customer service"
  default     = false
}

variable "enable_payments_service" {
  type        = bool
  description = "Add payments in EC2 to store as upstream"
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
}

variable "vault_database_secret_policy" {
  type        = string
  description = "Vault database secret read policy"
}

variable "certificate_arn" {
  type        = string
  description = "Certificate ARN for load balancer"
}

locals {
  service_ports = {
    store     = 9090
    customers = 9090
    database  = 9090
  }
}
