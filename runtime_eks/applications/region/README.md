# Deploying Resources to a Region

This module deploys common regional resources across AWS regions.

It creates the following resources:

- `store` service
- `customers` service
- `database` service
- Consul
    - Mesh gateway ACL configuration - for cross-partition access
    - Sameness group (`common`)
    - Terminating gateway ACL configuration - for database access
    - Exported services (`customers`, `store`)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_consul"></a> [consul](#requirement\_consul) | >= 2.19 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.13 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 3.22 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_consul"></a> [consul](#provider\_consul) | >= 2.19 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.23.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | >= 3.22 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_customers"></a> [customers](#module\_customers) | ../modules/fake-service | n/a |
| <a name="module_database"></a> [database](#module\_database) | ../modules/fake-service-db | n/a |
| <a name="module_store"></a> [store](#module\_store) | ../modules/fake-service | n/a |

## Resources

| Name | Type |
|------|------|
| [consul_acl_policy.mesh_gateway_partitions](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/acl_policy) | resource |
| [consul_acl_policy.terminating_gateway_database](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/acl_policy) | resource |
| [consul_acl_role_policy_attachment.mesh_gateway_partitions](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/acl_role_policy_attachment) | resource |
| [consul_acl_role_policy_attachment.terminating_gateway_database](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/acl_role_policy_attachment) | resource |
| [kubernetes_manifest.exported_services_default](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.sameness_group](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.service_intentions_customers](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.service_intentions_database](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.service_intentions_database_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.service_intentions_payments](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.service_intentions_store](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.service_resolver_store_to_payments](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.terminating_gateway](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [vault_kubernetes_auth_backend_role.database](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kubernetes_auth_backend_role) | resource |
| [consul_acl_role.mesh_gateway](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/data-sources/acl_role) | data source |
| [consul_acl_role.terminating_gateway](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/data-sources/acl_role) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | Certificate ARN for load balancer | `string` | n/a | yes |
| <a name="input_database_port"></a> [database\_port](#input\_database\_port) | Port for database service | `number` | `5432` | no |
| <a name="input_enable_payments_service"></a> [enable\_payments\_service](#input\_enable\_payments\_service) | Add payments in EC2 to store as upstream | `bool` | `false` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for services | `string` | n/a | yes |
| <a name="input_peers_for_failover"></a> [peers\_for\_failover](#input\_peers\_for\_failover) | Cluster peers for failover | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | Region of service | `string` | n/a | yes |
| <a name="input_sameness_group_name"></a> [sameness\_group\_name](#input\_sameness\_group\_name) | Name of sameness group | `string` | `"common"` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Service name for gateway | `string` | n/a | yes |
| <a name="input_test_failover_customers"></a> [test\_failover\_customers](#input\_test\_failover\_customers) | Test failover across regions for customer service | `bool` | `false` | no |
| <a name="input_vault_database_path"></a> [vault\_database\_path](#input\_vault\_database\_path) | Vault database path to allow application to access database credentials | `string` | n/a | yes |
| <a name="input_vault_database_secret_policy"></a> [vault\_database\_secret\_policy](#input\_vault\_database\_secret\_policy) | Vault database secret read policy | `string` | n/a | yes |
| <a name="input_vault_database_secret_role"></a> [vault\_database\_secret\_role](#input\_vault\_database\_secret\_role) | Vault database secret role to allow application to access database credentials | `string` | n/a | yes |
| <a name="input_vault_kubernetes_auth_path"></a> [vault\_kubernetes\_auth\_path](#input\_vault\_kubernetes\_auth\_path) | Vault Kubernetes authentication method path | `string` | n/a | yes |
| <a name="input_vault_namespace"></a> [vault\_namespace](#input\_vault\_namespace) | Vault namespace for database credentials | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sameness_group"></a> [sameness\_group](#output\_sameness\_group) | Name of the sameness group |
