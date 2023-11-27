# fake-service-db

Kubernetes manifests for deploying fake-service-db.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.13 |

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
| [kubernetes_manifest.vault_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.vault_dynamic_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_database_service_name"></a> [database\_service\_name](#input\_database\_service\_name) | Database service name | `string` | n/a | yes |
| <a name="input_database_service_port"></a> [database\_service\_port](#input\_database\_service\_port) | Database service port | `string` | n/a | yes |
| <a name="input_fake_service_db_container_image"></a> [fake\_service\_db\_container\_image](#input\_fake\_service\_db\_container\_image) | Fake service DB container image | `string` | `"rosemarywang/fake-service-db:v0.0.4"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of application | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace to deploy application | `string` | `"default"` | no |
| <a name="input_port"></a> [port](#input\_port) | Port of application | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region of application | `string` | n/a | yes |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Runtime of application | `string` | `"eks"` | no |
| <a name="input_vault_database_path"></a> [vault\_database\_path](#input\_vault\_database\_path) | Path to database secrets engine in Vault | `string` | n/a | yes |
| <a name="input_vault_database_secret_role"></a> [vault\_database\_secret\_role](#input\_vault\_database\_secret\_role) | Vault database secret role to allow application to access database credentials | `string` | n/a | yes |
| <a name="input_vault_kubernetes_auth_path"></a> [vault\_kubernetes\_auth\_path](#input\_vault\_kubernetes\_auth\_path) | Vault Kubernetes authentication method path | `string` | n/a | yes |
| <a name="input_vault_namespace"></a> [vault\_namespace](#input\_vault\_namespace) | Namespace of credentials in Vault | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_account_name"></a> [service\_account\_name](#output\_service\_account\_name) | Service account name |
