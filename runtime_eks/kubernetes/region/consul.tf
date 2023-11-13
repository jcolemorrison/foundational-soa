data "hcp_consul_agent_kubernetes_secret" "cluster" {
  cluster_id = var.hcp_consul_cluster_id
}

data "hcp_consul_agent_helm_config" "cluster" {
  cluster_id          = var.hcp_consul_cluster_id
  kubernetes_endpoint = var.kubernetes_endpoint
}

data "hcp_consul_cluster" "cluster" {
  cluster_id = var.hcp_consul_cluster_id
}

resource "hcp_consul_cluster_root_token" "token" {
  cluster_id = var.hcp_consul_cluster_id
}

locals {
  consul_secrets    = yamldecode(data.hcp_consul_agent_kubernetes_secret.cluster.secret)
  consul_root_token = yamldecode(hcp_consul_cluster_root_token.token.kubernetes_secret)
}

resource "kubernetes_namespace" "consul" {
  metadata {
    name = var.consul_namespace
  }
}

## Store HCP Consul credentials for telemetry

resource "kubernetes_secret" "hcp_consul_observability_credentials" {
  count = var.hcp_consul_observability != null ? 1 : 0
  metadata {
    name        = "consul-hcp-observability"
    namespace   = kubernetes_namespace.consul.metadata.0.name
    annotations = {}
    labels      = {}
  }

  data = {
    client-id     = var.hcp_consul_observability.client_id
    client-secret = var.hcp_consul_observability.client_secret
    resource-id   = var.hcp_consul_observability.resource_id
  }
}


## Store HCP Consul secrets

resource "kubernetes_secret" "hcp_consul_secret" {
  metadata {
    name        = local.consul_secrets.metadata.name
    namespace   = kubernetes_namespace.consul.metadata.0.name
    annotations = {}
    labels      = {}
  }

  data = {
    gossipEncryptionKey = base64decode(local.consul_secrets.data.gossipEncryptionKey)
    caCert              = base64decode(local.consul_secrets.data.caCert)
  }

  type = local.consul_secrets.type
}

## Store HCP Consul bootstrap token

resource "kubernetes_secret" "hcp_consul_token" {
  metadata {
    name        = local.consul_root_token.metadata.name
    namespace   = kubernetes_namespace.consul.metadata.0.name
    annotations = {}
    labels      = {}
  }

  data = {
    token = hcp_consul_cluster_root_token.token.secret_id
  }

  type = local.consul_root_token.type
}

locals {
  helm_values = [
    data.hcp_consul_agent_helm_config.cluster.config,
    file("${path.module}/templates/hcp.yaml"),
    var.hcp_consul_observability != null ? file("${path.module}/templates/telemetry.yaml") : ""
  ]
}

resource "helm_release" "consul" {
  depends_on       = [kubernetes_secret.hcp_consul_secret, kubernetes_secret.hcp_consul_token]
  name             = "consul"
  namespace        = kubernetes_namespace.consul.metadata.0.name
  create_namespace = false

  repository = "https://helm.releases.hashicorp.com"
  chart      = "consul"
  version    = var.consul_helm_version

  values = local.helm_values
}