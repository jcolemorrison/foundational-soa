resource "aws_secretsmanager_secret" "bootstrap_token" {
  name = "${var.region}-bootstrap-token"
}

resource "aws_secretsmanager_secret_version" "bootstrap_token" {
  secret_id     = aws_secretsmanager_secret.bootstrap_token.id
  secret_string = var.consul_bootstrap_token
}

resource "aws_secretsmanager_secret" "consul_ca_cert" {
  name_prefix = "${var.region}-consul-ca-cert"
}

data "http" "consul_service_mesh_ca" {
  url = "${var.consul_public_address}/v1/connect/ca/roots"

  request_headers = {
    X-Consul-Token = var.consul_bootstrap_token
    Accept         = "application/json"
  }
}

resource "aws_secretsmanager_secret_version" "consul_ca_cert" {
  depends_on    = [data.http.consul_service_mesh_ca]
  secret_id     = aws_secretsmanager_secret.consul_ca_cert.id
  secret_string = jsondecode(data.http.consul_service_mesh_ca.response_body)["Roots"][0]["RootCert"]
}
