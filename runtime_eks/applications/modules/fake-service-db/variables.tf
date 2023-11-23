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

variable "database_service_name" {
  type        = string
  description = "Database service name"
}

variable "database_service_port" {
  type        = string
  description = "Database service port"
}

variable "vault_namespace" {
  type        = string
  description = "Namespace of credentials in Vault"
}

variable "vault_database_path" {
  type        = string
  description = "Path to database secrets engine in Vault"
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

variable "fake_service_db_container_image" {
  type        = string
  description = "Fake service DB container image"
  default     = "rosemarywang/fake-service-db:v0.0.3"
}