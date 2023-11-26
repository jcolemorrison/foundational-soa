# resource "kubernetes_manifest" "gateway_consul_api_gateway" {
#   manifest = {
#     "apiVersion" = "gateway.networking.k8s.io/v1beta1"
#     "kind"       = "Gateway"
#     "metadata" = {
#       "annotations" = {
#         "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type" = "ip"
#         "service.beta.kubernetes.io/aws-load-balancer-type"            = "external"
#       }
#       "name"      = "api-gateway"
#       "namespace" = "consul"
#     }
#     "spec" = {
#       "gatewayClassName" = "consul"
#       "listeners" = [
#         {
#           "allowedRoutes" = {
#             "namespaces" = {
#               "from" = "All"
#             }
#           }
#           "name"     = "http"
#           "port"     = 80
#           "protocol" = "HTTP"
#         },
#       ]
#     }
#   }
# }

# resource "kubernetes_manifest" "clusterrolebinding_consul_api_gateway_tokenreview_binding" {
#   manifest = {
#     "apiVersion" = "rbac.authorization.k8s.io/v1"
#     "kind"       = "ClusterRoleBinding"
#     "metadata" = {
#       "name" = "consul-api-gateway-tokenreview-binding"
#     }
#     "roleRef" = {
#       "apiGroup" = "rbac.authorization.k8s.io"
#       "kind"     = "ClusterRole"
#       "name"     = "system:auth-delegator"
#     }
#     "subjects" = [
#       {
#         "kind"      = "ServiceAccount"
#         "name"      = "consul-api-gateway"
#         "namespace" = "consul"
#       },
#     ]
#   }
# }

# resource "kubernetes_manifest" "clusterrole_consul_api_gateway_auth" {
#   manifest = {
#     "apiVersion" = "rbac.authorization.k8s.io/v1"
#     "kind"       = "ClusterRole"
#     "metadata" = {
#       "name" = "consul-api-gateway-auth"
#     }
#     "rules" = [
#       {
#         "apiGroups" = [
#           "",
#         ]
#         "resources" = [
#           "serviceaccounts",
#         ]
#         "verbs" = [
#           "get",
#         ]
#       },
#     ]
#   }
# }

# resource "kubernetes_manifest" "clusterrolebinding_consul_api_gateway_auth_binding" {
#   manifest = {
#     "apiVersion" = "rbac.authorization.k8s.io/v1"
#     "kind"       = "ClusterRoleBinding"
#     "metadata" = {
#       "name" = "consul-api-gateway-auth-binding"
#     }
#     "roleRef" = {
#       "apiGroup" = "rbac.authorization.k8s.io"
#       "kind"     = "ClusterRole"
#       "name"     = "consul-api-gateway-auth"
#     }
#     "subjects" = [
#       {
#         "kind"      = "ServiceAccount"
#         "name"      = "consul-api-gateway"
#         "namespace" = "consul"
#       },
#     ]
#   }
# }

# resource "kubernetes_manifest" "clusterrolebinding_consul_auth_binding" {
#   manifest = {
#     "apiVersion" = "rbac.authorization.k8s.io/v1"
#     "kind"       = "ClusterRoleBinding"
#     "metadata" = {
#       "name" = "consul-auth-binding"
#     }
#     "roleRef" = {
#       "apiGroup" = "rbac.authorization.k8s.io"
#       "kind"     = "ClusterRole"
#       "name"     = "consul-api-gateway-auth"
#     }
#     "subjects" = [
#       {
#         "kind"      = "ServiceAccount"
#         "name"      = "consul-server"
#         "namespace" = "consul"
#       },
#     ]
#   }
# }

# resource "kubernetes_manifest" "serviceaccount_consul_consul_api_gateway" {
#   manifest = {
#     "apiVersion"                   = "v1"
#     "automountServiceAccountToken" = true
#     "kind"                         = "ServiceAccount"
#     "metadata" = {
#       "name"      = "consul-api-gateway"
#       "namespace" = "consul"
#     }
#   }
# }

# resource "kubernetes_manifest" "secret_consul_consul_api_gateway_token" {
#   manifest = {
#     "apiVersion" = "v1"
#     "kind"       = "Secret"
#     "metadata" = {
#       "annotations" = {
#         "kubernetes.io/service-account.name" = "consul-api-gateway"
#       }
#       "name"      = "consul-api-gateway-token"
#       "namespace" = "consul"
#     }
#     "type" = "kubernetes.io/service-account-token"
#   }
# }
