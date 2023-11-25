locals {
  vault_path = "prod-ecs"
}

## Fictional API Key in Vault for usage with ECS Tasks

resource "vault_namespace" "service" {
  path = local.vault_path

  provider = vault.admin
}

resource "vault_mount" "static" {
  namespace   = vault_namespace.service.path
  path        = "kv"
  type        = "kv"
  options     = { version = "2" }
  description = "For static secrets related to ${local.vault_path}"

  provider = vault.admin
}

data "vault_policy_document" "static" {
  rule {
    path         = "${vault_mount.static.path}/data/*"
    capabilities = ["read"]
    description  = "Read static credentials in key-value store"
  }

  provider = vault.admin
}

resource "vault_policy" "static" {
  namespace = vault_namespace.service.path
  name      = "${local.vault_path}-static-read"
  policy    = data.vault_policy_document.static.hcl

  provider = vault.admin
}

resource "random_string" "random" {
  length    = 16
  special   = false
  min_lower = 3
  min_upper = 3
}

resource "vault_kv_secret_v2" "api_key" {
  namespace           = vault_namespace.service.path
  mount               = vault_mount.static.path
  name                = "${local.vault_path}-api-key"
  delete_all_versions = true

  data_json = <<EOT
{
  "apikey": "${random_string.random.result}"
}
EOT

  provider = vault.admin
}

## AWS Vault Auth Method

resource "vault_auth_backend" "aws" {
  type      = "aws"
  namespace = vault_namespace.service.path

  provider = vault.admin
}

resource "vault_aws_auth_backend_client" "aws" {
  backend                    = vault_auth_backend.aws.path
  namespace                  = vault_namespace.service.path
  access_key                 = aws_iam_access_key.vault_user.id
  secret_key                 = aws_iam_access_key.vault_user.secret
  use_sts_region_from_client = true

  depends_on = [aws_iam_access_key.vault_user]

  provider = vault.admin
}

resource "vault_aws_auth_backend_role" "aws_us_east_1" {
  backend                         = vault_auth_backend.aws.path
  namespace                       = vault_namespace.service.path
  role                            = "vault-ecs-role-${local.us_east_1}"
  auth_type                       = "iam"
  bound_iam_role_arns             = [aws_iam_role.container_instance.arn]
  bound_iam_instance_profile_arns = [aws_iam_instance_profile.container_instance_profile.arn]
  inferred_entity_type            = "ec2_instance"
  inferred_aws_region             = local.us_east_1
  token_ttl                       = 60
  token_max_ttl                   = 120
  token_policies                  = [vault_policy.static.name]

  provider = vault.admin
}

resource "vault_aws_auth_backend_role" "aws_us_west_2" {
  backend                         = vault_auth_backend.aws.path
  namespace                       = vault_namespace.service.path
  role                            = "vault-ecs-role-${local.us_west_2}"
  auth_type                       = "iam"
  bound_iam_role_arns             = [aws_iam_role.container_instance.arn]
  bound_iam_instance_profile_arns = [aws_iam_instance_profile.container_instance_profile.arn]
  inferred_entity_type            = "ec2_instance"
  inferred_aws_region             = local.us_west_2
  token_ttl                       = 60
  token_max_ttl                   = 120
  token_policies                  = [vault_policy.static.name]

  provider = vault.admin
}

resource "vault_aws_auth_backend_role" "aws_eu_west_1" {
  backend                         = vault_auth_backend.aws.path
  namespace                       = vault_namespace.service.path
  role                            = "vault-ecs-role-${local.eu_west_1}"
  auth_type                       = "iam"
  bound_iam_role_arns             = [aws_iam_role.container_instance.arn]
  bound_iam_instance_profile_arns = [aws_iam_instance_profile.container_instance_profile.arn]
  inferred_entity_type            = "ec2_instance"
  inferred_aws_region             = local.eu_west_1
  token_ttl                       = 60
  token_max_ttl                   = 120
  token_policies                  = [vault_policy.static.name]

  provider = vault.admin
}