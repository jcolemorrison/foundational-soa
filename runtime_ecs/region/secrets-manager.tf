resource "aws_secretsmanager_secret" "bootstrap_token" {
  name = "${var.region}-bootstrap-token"
}

resource "aws_secretsmanager_secret_version" "bootstrap_token" {
  secret_id     = aws_secretsmanager_secret.bootstrap_token.id
  secret_string = var.consul_bootstrap_token
}