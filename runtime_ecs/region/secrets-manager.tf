resource "aws_secretsmanager_secret" "bootstrap_token" {
  name = "${var.region}-bootstrap-token"
}

resource "aws_secretsmanager_secret_version" "bootstrap_token" {
  secret_id     = aws_secretsmanager_secret.bootstrap_token.id
  secret_string = var.consul_bootstrap_token
}

resource "aws_secretsmanager_secret" "consul_ca_cert" {
  name = "${var.region}-consul-ca-cert"
}

resource "aws_secretsmanager_secret_version" "consul_ca_cert" {
  secret_id = aws_secretsmanager_secret.consul_ca_cert.id
  secret_string = base64decode(data.hcp_consul_cluster.region.consul_ca_file)
}