terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.13"
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 3.22"
    }
    consul = {
      source  = "hashicorp/consul"
      version = ">= 2.19"
    }
  }
}