# Database Secrets Engine in Vault for Services

This module configures the database secrets engine in Vault
for an application service. It also stores the administrative username
and password from RDS into a key-value secrets mount.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | ~> 3.22 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vault"></a> [vault](#provider\_vault) | ~> 3.22 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [vault_database_secret_backend_connection.database](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/database_secret_backend_connection) | resource |
| [vault_database_secret_backend_role.database](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/database_secret_backend_role) | resource |
| [vault_kv_secret_v2.database](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_mount.database](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/mount) | resource |
| [vault_mount.static](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/mount) | resource |
| [vault_policy.database](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |
| [vault_policy.database_admin](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |
| [vault_policy.static](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |
| [vault_policy_document.database](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/policy_document) | data source |
| [vault_policy_document.database_admin](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/policy_document) | data source |
| [vault_policy_document.static](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_address"></a> [db\_address](#input\_db\_address) | Database address | `string` | `null` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Name of database to enable database secrets engine | `string` | `null` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Database password | `string` | `null` | no |
| <a name="input_db_port"></a> [db\_port](#input\_db\_port) | Database port | `string` | `null` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Database username | `string` | `null` | no |
| <a name="input_service"></a> [service](#input\_service) | Name of service | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_secrets_path"></a> [database\_secrets\_path](#output\_database\_secrets\_path) | Path to database credentials |
| <a name="output_database_secrets_policies"></a> [database\_secrets\_policies](#output\_database\_secrets\_policies) | Name of Vault policies that allows admin or read access to database secrets engine for service |
| <a name="output_database_secrets_role"></a> [database\_secrets\_role](#output\_database\_secrets\_role) | Vault role for database credentials |
| <a name="output_static_secrets_path"></a> [static\_secrets\_path](#output\_static\_secrets\_path) | Path to secrets in key-value store, including database administrative password |
| <a name="output_static_secrets_policy"></a> [static\_secrets\_policy](#output\_static\_secrets\_policy) | Name of Vault policy that allows access to all static secrets for service |
