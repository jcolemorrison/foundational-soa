data "kubernetes_service" "store_us_east_1" {
  metadata {
    name      = "store"
    namespace = var.namespace
  }
  provider = kubernetes.us_east_1
}

data "kubernetes_service" "store_us_west_2" {
  metadata {
    name      = "store"
    namespace = var.namespace
  }
  provider = kubernetes.us_west_2
}

data "kubernetes_service" "store_eu_west_1" {
  metadata {
    name      = "store"
    namespace = var.namespace
  }
  provider = kubernetes.eu_west_1
}

output "store_endpoints" {
  value = {
    us_east_1 = "http://${data.kubernetes_service.store_us_east_1.status[0].load_balancer[0].ingress[0].hostname}:9090"
    us_west_2 = "http://${data.kubernetes_service.store_us_west_2.status[0].load_balancer[0].ingress[0].hostname}:9090"
    eu_west_1 = "http://${data.kubernetes_service.store_eu_west_1.status[0].load_balancer[0].ingress[0].hostname}:9090"
  }
  description = "Endpoints for store service"
}