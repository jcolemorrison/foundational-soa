variable "validity_in_seconds" {
    type = string
    description = "Certificate validity in seconds"
}

variable "consul_connect_pki_path" {
    type = string
    description = "Root PKI path for Consul CA"
}

variable "pki_int_path" {
    type = string
    description = "PKI intermediate path prefix"
}

variable "namespace" {
    type = string
    description = "Vault namespace for Consul CA"
}

variable "region" {
    type = string
    description = "Region for intermediate certificates"
}

variable "certificate_chain" {
    type = string
    description = "Root and other intermediate level certificates"
}

variable "vault_policy_consul_ca" {
    type = string
    description = "Vault policy for root Consul CA"
}

locals {
    region_suffix = replace(var.region, "-", "_")
}