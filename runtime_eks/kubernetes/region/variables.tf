# Attributes for deploying Vault Helm Chart
variable "vault_namespace" {
  type        = string
  description = "Kubernetes namespace for Vault"
  default     = "vault"
}

variable "vault_helm_version" {
  type        = string
  description = "Vault Helm chart version"
  default     = "0.26.1"
}

variable "vault_operator_helm_version" {
  type        = string
  description = "Secrets Store CSI Driver Helm chart version"
  default     = "0.3.4"
}

variable "hcp_vault_private_address" {
  type        = string
  description = "HCP Vault private address"
}

# Attributes for deploying Consul Helm Chart
variable "consul_namespace" {
  type        = string
  description = "Kubernetes namespace for Consul"
  default     = "consul"
}

variable "consul_helm_version" {
  type        = string
  description = "Consul Helm chart version"
  default     = "1.3.0"
}

variable "hcp_consul_cluster_id" {
  type        = string
  description = "HCP Consul cluster ID"
}

variable "hcp_consul_observability" {
  type = object({
    client_id     = string
    client_secret = string
    resource_id   = string
  })
  description = "HCP Consul observability credentials for telemetry collector"
  default     = null
  sensitive   = true
}

variable "kubernetes_endpoint" {
  type        = string
  description = "Kubernetes cluster endpoint"
}

## AWS Load Balancer Controller
variable "aws_lb_controller_helm_version" {
  type        = string
  description = "AWS Load Balancer Controller Helm chart version"
  default     = "1.6.2"
}

variable "aws_lb_controller_namespace" {
  type        = string
  description = "AWS Load Balancer Controller namespace"
  default     = "kube-system"
}

variable "aws_lb_controller_service_account" {
  type        = string
  description = "AWS Load Balancer Controller service account"
  default     = "aws-load-balancer-controller"
}

variable "aws_lb_controller_irsa_role_arn" {
  type        = string
  description = "AWS Load Balancer Controller IRSA role ARN"
}

variable "cluster_name" {
  type        = string
  description = "Name of EKS cluster"
}
