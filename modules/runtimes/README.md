# Runtime Constants

This module generates some constants for various runtimes.

## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_map"></a> [access\_map](#input\_access\_map) | Map of service team access to runtimes | `map(list(string))` | <pre>{<br>  "ec2": [<br>    "payments",<br>    "reports"<br>  ],<br>  "ecs": [],<br>  "eks": [<br>    "store",<br>    "customers",<br>    "database"<br>  ],<br>  "frontend": [<br>    "frontend"<br>  ]<br>}</pre> | no |
| <a name="input_runtimes"></a> [runtimes](#input\_runtimes) | Set of runtimes for Consul cluster peering | `set(string)` | <pre>[<br>  "default",<br>  "eks",<br>  "ecs",<br>  "ec2",<br>  "frontend"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_list"></a> [list](#output\_list) | List of runtimes |
| <a name="output_service_access"></a> [service\_access](#output\_service\_access) | Map of service teams access to runtimes |
