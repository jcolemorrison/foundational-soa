# Database Target in Boundary

This module configures a database target with host set and adds it
to Boundary.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_boundary"></a> [boundary](#requirement\_boundary) | >= 1.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_boundary"></a> [boundary](#provider\_boundary) | 1.1.10 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [boundary_credential_library_vault.database](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/credential_library_vault) | resource |
| [boundary_host_catalog_static.database](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/host_catalog_static) | resource |
| [boundary_host_set_static.database](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/host_set_static) | resource |
| [boundary_host_static.database](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/host_static) | resource |
| [boundary_target.database](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/target) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_level"></a> [access\_level](#input\_access\_level) | Describe access to target, must be write or read | `string` | `"read"` | no |
| <a name="input_boundary_credentials_store_id"></a> [boundary\_credentials\_store\_id](#input\_boundary\_credentials\_store\_id) | Credentials store ID for Boundary scope | `string` | n/a | yes |
| <a name="input_boundary_scope_id"></a> [boundary\_scope\_id](#input\_boundary\_scope\_id) | ID of Boudnary scope to add database connnection | `string` | n/a | yes |
| <a name="input_db_host"></a> [db\_host](#input\_db\_host) | Database host | `string` | n/a | yes |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Database name | `string` | n/a | yes |
| <a name="input_db_port"></a> [db\_port](#input\_db\_port) | Database port | `number` | n/a | yes |
| <a name="input_egress_worker_filter"></a> [egress\_worker\_filter](#input\_egress\_worker\_filter) | Target egress worker filter for Boundary. | `string` | n/a | yes |
| <a name="input_ingress_worker_filter"></a> [ingress\_worker\_filter](#input\_ingress\_worker\_filter) | Target ingress worker filter for Boundary. | `string` | n/a | yes |
| <a name="input_service"></a> [service](#input\_service) | Name of service to identify instance | `string` | n/a | yes |
| <a name="input_vault_path_to_database_credentials"></a> [vault\_path\_to\_database\_credentials](#input\_vault\_path\_to\_database\_credentials) | Path in Vault to database credentials. | `string` | n/a | yes |

## Outputs

No outputs.
