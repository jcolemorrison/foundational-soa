resource "kubernetes_manifest" "exported_services_default" {
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ExportedServices"
    "metadata" = {
      "name"      = "default"
      "namespace" = var.namespace
    }
    "spec" = {
      "services" = [
        {
          "consumers" = local.partitions
          "name"      = "mesh-gateway"
        },
        {
          "consumers" = [
            {
              "samenessGroup" = var.sameness_group_name
            },
          ]
          "name" = "customers"
        },
        {
          "consumers" = [
            {
              "samenessGroup" = var.sameness_group_name
            },
          ]
          "name" = "payments"
        },
        {
          "consumers" = [
            {
              "samenessGroup" = var.sameness_group_name
            },
          ]
          "name" = "store"
        },
      ]
    }
  }
}
