# fake-service

Kubernetes manifests for deploying fake-service.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.23.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_static"></a> [static](#module\_static) | ../../../../modules/fake_service | n/a |

## Resources

| Name | Type |
|------|------|
| [kubernetes_manifest.deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.service_account](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.service_defaults](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | Certificate ARN for load balancer | `string` | `null` | no |
| <a name="input_enable_load_balancer"></a> [enable\_load\_balancer](#input\_enable\_load\_balancer) | Enable load balancer for service | `string` | `false` | no |
| <a name="input_error_code"></a> [error\_code](#input\_error\_code) | HTTP status code to return on error | `string` | `"500"` | no |
| <a name="input_error_rate"></a> [error\_rate](#input\_error\_rate) | Error rate as a percentage to pass onto the application | `number` | `0` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of application | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace to deploy application | `string` | `"default"` | no |
| <a name="input_port"></a> [port](#input\_port) | Port of application | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region of application | `string` | n/a | yes |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Runtime of application | `string` | `"eks"` | no |
| <a name="input_upstream_uris"></a> [upstream\_uris](#input\_upstream\_uris) | Comma-delimited set of upstreams URIs for service to connect | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_account_name"></a> [service\_account\_name](#output\_service\_account\_name) | Service account name |
