# Host Target in Boundary

This module configures a generic target with host set and adds it
to Boundary.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_boundary"></a> [boundary](#requirement\_boundary) | >= 1.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_boundary"></a> [boundary](#provider\_boundary) | >= 1.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [boundary_host_catalog_static.catalog](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/host_catalog_static) | resource |
| [boundary_host_set_static.host_set](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/host_set_static) | resource |
| [boundary_host_static.host](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/host_static) | resource |
| [boundary_target.target](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/target) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_port"></a> [default\_port](#input\_default\_port) | Target default port. | `number` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description for host catalog and host sets. | `string` | n/a | yes |
| <a name="input_egress_worker_filter"></a> [egress\_worker\_filter](#input\_egress\_worker\_filter) | Target egress worker filter for Boundary. | `string` | n/a | yes |
| <a name="input_ingress_worker_filter"></a> [ingress\_worker\_filter](#input\_ingress\_worker\_filter) | Target ingress worker filter for Boundary. | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name prefix for Boundary host catalog. | `string` | n/a | yes |
| <a name="input_scope_id"></a> [scope\_id](#input\_scope\_id) | Scope ID for Boundary host catalog | `string` | n/a | yes |
| <a name="input_session_connection_limit"></a> [session\_connection\_limit](#input\_session\_connection\_limit) | Target session connection limit. | `number` | `-1` | no |
| <a name="input_target_ips"></a> [target\_ips](#input\_target\_ips) | Map of instance ID and IP address of hosts to register | `map(string)` | n/a | yes |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | Target type for Boundary. | `string` | `"tcp"` | no |

## Outputs

No outputs.
