# Terraform Module for AWS and HashiCorp Cloud Platform

This module configures the following components for HCP:

- HashiCorp Virtual Network (HVN)
- Transit gateway between HVN and VPC
- (Optional) HashiCorp Cloud Platform (HCP) Consul cluster
- (Optional) HashiCorp Cloud Platform (HCP) Vault cluster
- (Optional) HashiCorp Cloud Platform (HCP) Boundary cluster

## Prerequisites

You must have access to [HashiCorp Cloud Platform (HCP)](https://www.hashicorp.com/cloud-platform/).
Create an HCP [service principal](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/guides/auth)
before using the [HCP Provider for Terraform](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs).

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.22 |
| <a name="requirement_hcp"></a> [hcp](#requirement\_hcp) | >= 0.75 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.22.0 |
| <a name="provider_hcp"></a> [hcp](#provider\_hcp) | 0.75.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ram_principal_association.transit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_security_group_rule.hcp_consul](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.hcp_consul_clients](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [hcp_aws_transit_gateway_attachment.hcp](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/aws_transit_gateway_attachment) | resource |
| [hcp_boundary_cluster.boundary](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/boundary_cluster) | resource |
| [hcp_consul_cluster.consul](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/consul_cluster) | resource |
| [hcp_consul_cluster_root_token.consul](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/consul_cluster_root_token) | resource |
| [hcp_hvn.hvn](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/hvn) | resource |
| [hcp_hvn_route.route](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/hvn_route) | resource |
| [hcp_vault_cluster.vault](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/vault_cluster) | resource |
| [hcp_vault_cluster_admin_token.vault](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/vault_cluster_admin_token) | resource |
| [random_password.boundary](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_pet.boundary](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_ram_resource_share_arn"></a> [aws\_ram\_resource\_share\_arn](#input\_aws\_ram\_resource\_share\_arn) | AWS RAM resource share ARN. | `string` | n/a | yes |
| <a name="input_hcp_boundary_name"></a> [hcp\_boundary\_name](#input\_hcp\_boundary\_name) | Name for HCP Boundary cluster. If left as an empty string, a cluster will not be created. | `string` | `null` | no |
| <a name="input_hcp_boundary_tier"></a> [hcp\_boundary\_tier](#input\_hcp\_boundary\_tier) | HCP Boundary Tier | `string` | `"Standard"` | no |
| <a name="input_hcp_consul_datacenter"></a> [hcp\_consul\_datacenter](#input\_hcp\_consul\_datacenter) | Datacenter for HCP Consul cluster. If undefined, uses `hcp_consul_name`. | `string` | `null` | no |
| <a name="input_hcp_consul_name"></a> [hcp\_consul\_name](#input\_hcp\_consul\_name) | Name for HCP Consul cluster. If left as an empty string, a cluster will not be created. | `string` | `null` | no |
| <a name="input_hcp_consul_peering"></a> [hcp\_consul\_peering](#input\_hcp\_consul\_peering) | Enable peering of HCP Consul clusters | `bool` | `false` | no |
| <a name="input_hcp_consul_primary_link"></a> [hcp\_consul\_primary\_link](#input\_hcp\_consul\_primary\_link) | `self_link` of the HCP Consul primary cluster for federation | `string` | `null` | no |
| <a name="input_hcp_consul_public_endpoint"></a> [hcp\_consul\_public\_endpoint](#input\_hcp\_consul\_public\_endpoint) | Enable public endpoint for HCP Consul cluster. | `bool` | `false` | no |
| <a name="input_hcp_consul_security_group_ids"></a> [hcp\_consul\_security\_group\_ids](#input\_hcp\_consul\_security\_group\_ids) | Security Group IDs to allow HCP Consul. | `list(string)` | `[]` | no |
| <a name="input_hcp_consul_tier"></a> [hcp\_consul\_tier](#input\_hcp\_consul\_tier) | Tier for HCP Consul cluster. Must be `development`, `standard`, or `plus`. | `string` | `"development"` | no |
| <a name="input_hcp_consul_version"></a> [hcp\_consul\_version](#input\_hcp\_consul\_version) | Minimum Consul version. Defaults to HCP recommendation. | `string` | `null` | no |
| <a name="input_hcp_vault_name"></a> [hcp\_vault\_name](#input\_hcp\_vault\_name) | Name for HCP Vault cluster. If left as an empty string, a cluster will not be created. | `string` | `null` | no |
| <a name="input_hcp_vault_paths_filter"></a> [hcp\_vault\_paths\_filter](#input\_hcp\_vault\_paths\_filter) | Path filter for HCP Vault performance replication. | `list(string)` | `null` | no |
| <a name="input_hcp_vault_primary_link"></a> [hcp\_vault\_primary\_link](#input\_hcp\_vault\_primary\_link) | `self_link` of the HCP Vault primary cluster for performance replication. | `string` | `null` | no |
| <a name="input_hcp_vault_public_endpoint"></a> [hcp\_vault\_public\_endpoint](#input\_hcp\_vault\_public\_endpoint) | Enable public endpoint for HCP Vault cluster. | `bool` | `false` | no |
| <a name="input_hcp_vault_tier"></a> [hcp\_vault\_tier](#input\_hcp\_vault\_tier) | Tier for HCP Vault cluster. See [pricing information](https://cloud.hashicorp.com/pricing/vault?_ga=2.162839740.1812223219.1631540747-2080033703.1609969902) | `string` | `"dev"` | no |
| <a name="input_hcp_vault_version"></a> [hcp\_vault\_version](#input\_hcp\_vault\_version) | Minimum Vault version. Defaults to HCP recommendation. | `string` | `null` | no |
| <a name="input_hvn_cidr_block"></a> [hvn\_cidr\_block](#input\_hvn\_cidr\_block) | CIDR Block of HashiCorp Virtual Network. Cannot overlap with `vpc_cidr_block`. | `string` | n/a | yes |
| <a name="input_hvn_name"></a> [hvn\_name](#input\_hvn\_name) | Name of HashiCorp Virtual Network. | `string` | n/a | yes |
| <a name="input_hvn_region"></a> [hvn\_region](#input\_hvn\_region) | AWS region for HashiCorp Virtual Network. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for AWS resources | `map(string)` | `{}` | no |
| <a name="input_transit_gateway_arn"></a> [transit\_gateway\_arn](#input\_transit\_gateway\_arn) | Transit gateway ARN. | `string` | n/a | yes |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | Transit gateway ID. | `string` | n/a | yes |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | VPC CIDR block to route with HVN | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hcp_boundary"></a> [hcp\_boundary](#output\_hcp\_boundary) | HCP Boundary cluster details |
| <a name="output_hcp_consul"></a> [hcp\_consul](#output\_hcp\_consul) | HCP Consul cluster details |
| <a name="output_hcp_vault"></a> [hcp\_vault](#output\_hcp\_vault) | HCP Vault cluster details |
| <a name="output_hvn_id"></a> [hvn\_id](#output\_hvn\_id) | ID of HashiCorp Virtual Network. |
