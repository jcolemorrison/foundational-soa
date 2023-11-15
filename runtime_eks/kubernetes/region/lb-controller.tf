resource "helm_release" "lbc" {
  name       = "aws-load-balancer-controller"
  chart      = "aws-load-balancer-controller"
  version    = var.aws_lb_controller_helm_version
  repository = "https://aws.github.io/eks-charts"
  namespace  = var.aws_lb_controller_namespace

  dynamic "set" {
    for_each = {
      "clusterName"                                               = var.cluster_name
      "serviceAccount.name"                                       = var.aws_lb_controller_service_account
      "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" = var.aws_lb_controller_irsa_role_arn
    }
    content {
      name  = set.key
      value = set.value
    }
  }
}