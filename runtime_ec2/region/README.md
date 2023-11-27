# Deploying Resources to a Region

This module deploys common regional resources across AWS regions.

It creates the following resources:

- VPC for the runtime
- `payments` and `reports` services on EC2 instances
- Consul mesh gateway on an EC2 instance
- Consul configuration entries
    - Sameness group (`common`)
    - Exported services for `payments`
    - Intentions to allow connections to payments
      - `reports` in same partition (`ec2`)
      - `store` in EKS partition (`default`)
      - `ecs-api` in ECS partition (`ecs`)
- Boundary workers to log into EC2 instances
    - AWS keypair to add to workers and EC2 instances
- Boundary targets to...
  - `payments` and `report` services on EC2 instances
  - Consul mesh gateway on an EC2 instance
- Security group rules to allow access to mesh gateways, Boundary workers, and application instances

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.23 |
| <a name="requirement_boundary"></a> [boundary](#requirement\_boundary) | >= 1.1 |
| <a name="requirement_consul"></a> [consul](#requirement\_consul) | >= 2.19 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 3.22 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.23.1 |
| <a name="provider_boundary"></a> [boundary](#provider\_boundary) | 1.1.10 |
| <a name="provider_consul"></a> [consul](#provider\_consul) | >= 2.19 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 3.23.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_boundary_consul_mesh_gateway_targets"></a> [boundary\_consul\_mesh\_gateway\_targets](#module\_boundary\_consul\_mesh\_gateway\_targets) | ../../modules/boundary/hosts | n/a |
| <a name="module_boundary_ec2_targets"></a> [boundary\_ec2\_targets](#module\_boundary\_ec2\_targets) | ../../modules/boundary/hosts | n/a |
| <a name="module_boundary_worker"></a> [boundary\_worker](#module\_boundary\_worker) | ../../modules/boundary/worker | n/a |
| <a name="module_mesh_gateway"></a> [mesh\_gateway](#module\_mesh\_gateway) | ../modules/consul/mesh_gateway | n/a |
| <a name="module_network"></a> [network](#module\_network) | ../../modules/runtime_network | n/a |
| <a name="module_payments"></a> [payments](#module\_payments) | ../modules/ec2 | n/a |
| <a name="module_payments_static"></a> [payments\_static](#module\_payments\_static) | ../../modules/fake_service | n/a |
| <a name="module_reports"></a> [reports](#module\_reports) | ../modules/ec2 | n/a |
| <a name="module_reports_static"></a> [reports\_static](#module\_reports\_static) | ../../modules/fake_service | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_key_pair.boundary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_security_group.instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [boundary_worker.eks](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/worker) | resource |
| [consul_config_entry.exported_services_payments_ec2](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/config_entry) | resource |
| [consul_config_entry.payments_intentions](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/config_entry) | resource |
| [consul_config_entry.sameness_group](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/config_entry) | resource |
| [consul_config_entry.service_defaults_payments](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/config_entry) | resource |
| [consul_config_entry.service_defaults_reports](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/config_entry) | resource |
| [random_integer.mesh_gateway](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [random_integer.payments_subnet](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [tls_private_key.boundary](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_instances.boundary_worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instances) | data source |
| [aws_instances.consul_mesh_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instances) | data source |
| [aws_instances.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instances) | data source |
| [vault_kv_secret_v2.boundary_worker_token_eks](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/kv_secret_v2) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accessible_cidr_blocks"></a> [accessible\_cidr\_blocks](#input\_accessible\_cidr\_blocks) | List of CIDR blocks to point to the transit gateway in addition to the Shared Services sandbox and HCP HVN | `list(string)` | `[]` | no |
| <a name="input_boundary_cluster_id"></a> [boundary\_cluster\_id](#input\_boundary\_cluster\_id) | Boundary cluster ID for workers to register | `string` | `null` | no |
| <a name="input_boundary_project_scope_id"></a> [boundary\_project\_scope\_id](#input\_boundary\_project\_scope\_id) | Boundary project scope ID for EKS runtime | `string` | n/a | yes |
| <a name="input_boundary_worker_vault_namespace"></a> [boundary\_worker\_vault\_namespace](#input\_boundary\_worker\_vault\_namespace) | Namespace in Vault for Boundary worker to store secret | `string` | `null` | no |
| <a name="input_boundary_worker_vault_namespace_absolute"></a> [boundary\_worker\_vault\_namespace\_absolute](#input\_boundary\_worker\_vault\_namespace\_absolute) | Namespace in Vault for Boundary worker to store secret, includes full path | `string` | `null` | no |
| <a name="input_boundary_worker_vault_path"></a> [boundary\_worker\_vault\_path](#input\_boundary\_worker\_vault\_path) | Path in Vault for Boundary worker to store secret | `string` | `null` | no |
| <a name="input_boundary_worker_vault_token"></a> [boundary\_worker\_vault\_token](#input\_boundary\_worker\_vault\_token) | Token in Vault for Boundary worker to store secret | `string` | `null` | no |
| <a name="input_create_boundary_workers"></a> [create\_boundary\_workers](#input\_create\_boundary\_workers) | Create Boundary workers, one per public subnet | `bool` | `false` | no |
| <a name="input_deploy_services"></a> [deploy\_services](#input\_deploy\_services) | Deploy services in EC2 instances | `bool` | `false` | no |
| <a name="input_hcp_consul_cluster_id"></a> [hcp\_consul\_cluster\_id](#input\_hcp\_consul\_cluster\_id) | HCP Consul cluster ID | `string` | n/a | yes |
| <a name="input_hcp_consul_cluster_token"></a> [hcp\_consul\_cluster\_token](#input\_hcp\_consul\_cluster\_token) | Consul bootstrap token for clients to start | `string` | n/a | yes |
| <a name="input_hcp_hvn_cidr_block"></a> [hcp\_hvn\_cidr\_block](#input\_hcp\_hvn\_cidr\_block) | CIDR block of the HCP HVN. | `string` | n/a | yes |
| <a name="input_keypair"></a> [keypair](#input\_keypair) | Keypair | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of regional resources | `string` | n/a | yes |
| <a name="input_peers_for_failover"></a> [peers\_for\_failover](#input\_peers\_for\_failover) | Cluster peers for failover | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region to deploy the transit gateway to.  Only used for naming purposes. | `string` | n/a | yes |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Runtime | `string` | `"ec2"` | no |
| <a name="input_sameness_group"></a> [sameness\_group](#input\_sameness\_group) | Sameness group | `string` | `"common"` | no |
| <a name="input_shared_services_cidr_block"></a> [shared\_services\_cidr\_block](#input\_shared\_services\_cidr\_block) | CIDR block of the shared services sandbox. | `string` | n/a | yes |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | transit gateway ID to point traffic to for shared services, hcp, etc. | `string` | n/a | yes |
| <a name="input_vault_address"></a> [vault\_address](#input\_vault\_address) | Vault cluster address | `string` | `null` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | Cidr block for the VPC.  Using a /22 Subnet Mask for this project is recommended. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_keypair_name"></a> [keypair\_name](#output\_keypair\_name) | Boundary worker keypair |
| <a name="output_ssh_private_key"></a> [ssh\_private\_key](#output\_ssh\_private\_key) | Boundary worker SSH key |
