module "database" {
  source = "../modules/fake-service-db"

  region = var.region
  name   = "database"
  port   = local.service_ports.database

  vault_namespace            = var.vault_namespace
  vault_database_path        = var.vault_database_path
  vault_database_secret_role = var.vault_database_secret_role
  vault_kubernetes_auth_path = var.vault_kubernetes_auth_path

  database_service_name = "${var.service_name}-database"
  database_service_port = var.database_port
}

resource "kubernetes_manifest" "service_intentions_database" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ServiceIntentions"
    "metadata" = {
      "name"      = "database"
      "namespace" = var.namespace
    }
    "spec" = {
      "destination" = {
        "name" = "database"
      }
      "sources" = [
        {
          "action" = "allow"
          "name"   = "application"
        },
        {
          "action"        = "allow"
          "name"          = "application"
          "samenessGroup" = var.sameness_group_name
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "service_intentions_database_service" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ServiceIntentions"
    "metadata" = {
      "name"      = "${var.service_name}-database"
      "namespace" = var.namespace
    }
    "spec" = {
      "destination" = {
        "name" = "${var.service_name}-database"
      }
      "sources" = [
        {
          "action" = "allow"
          "name"   = "database"
        },
      ]
    }
  }
}
