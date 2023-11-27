# Fake Service Constants

This module generates some constants for fake-service,
including a name, message, and container image.

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
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | Default container image version | `string` | `"nicholasjackson/fake-service:v0.26.0"` | no |
| <a name="input_region"></a> [region](#input\_region) | Region of application | `string` | n/a | yes |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Runtime of application | `string` | n/a | yes |
| <a name="input_service"></a> [service](#input\_service) | Name of service | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_image"></a> [container\_image](#output\_container\_image) | Container image version to use for fake-service |
| <a name="output_message"></a> [message](#output\_message) | Fake-service message to pass to MESSAGE environment variable |
| <a name="output_name"></a> [name](#output\_name) | Fake-service name to pass to NAME environment variable |
