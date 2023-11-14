variable "consul_root_pki_path" {
  type        = string
  description = "Root PKI path for Consul service mesh CA"
}

variable "consul_int_pki_path" {
  type        = string
  description = "Intermediate PKI path prefix for Consul service mesh CA"
}

variable "namespace" {
  type        = string
  description = "Vault namespace for Consul CA"
}

variable "region" {
  type        = string
  description = "Region for intermediate certificates"
}

variable "vault_policy_consul_ca" {
  type        = string
  description = "Vault policy for root Consul service mesh CA"
}

locals {
  region_suffix       = replace(var.region, "-", "_")
  consul_int_pki_path = format("%s/%s", var.consul_int_pki_path, local.region_suffix)
}