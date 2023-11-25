variable "region" {
  type        = string
  description = "Region of cluster, used in Vault auth method path"
}

variable "kubernetes_endpoint" {
  type        = string
  description = "Kubernetes enpdoint"
}

variable "kubernetes_ca_cert" {
  type        = string
  description = "Kubernetes cluster CA certificate"
  sensitive   = true
}

variable "kubernetes_token" {
  type        = string
  description = "Kubernetes cluster token"
  sensitive   = true
}
