# Deploying Resources to a Region

This module deploys common regional resources across AWS regions.

It creates the following resources:

- VPC for the runtime
- EKS Cluster with node groups
- Boundary targets and workers
- RDS database cluster and instance
- Boundary workers to log into ECS constainer instances
    - AWS keypair to add to workers and ECS container instances
- Boundary targets to...
  - SSH into ECS container instances
- Route53 DNS and certificates

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
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 3.23.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_boundary_eks_gateway"></a> [boundary\_eks\_gateway](#module\_boundary\_eks\_gateway) | ../../modules/boundary/hosts | n/a |
| <a name="module_boundary_eks_hosts"></a> [boundary\_eks\_hosts](#module\_boundary\_eks\_hosts) | ../../modules/boundary/hosts | n/a |
| <a name="module_boundary_worker"></a> [boundary\_worker](#module\_boundary\_worker) | ../../modules/boundary/worker | n/a |
| <a name="module_database"></a> [database](#module\_database) | ../../modules/database | n/a |
| <a name="module_eks"></a> [eks](#module\_eks) | ../modules/eks | n/a |
| <a name="module_network"></a> [network](#module\_network) | ../../modules/runtime_network | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.subdomain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.subdomain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_key_pair.boundary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_route53_record.subdomain_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [boundary_worker.eks](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/worker) | resource |
| [consul_config_entry.service_defaults](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/config_entry) | resource |
| [consul_node.database](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/node) | resource |
| [consul_service.database](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/service) | resource |
| [tls_private_key.boundary](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [vault_kv_secret_v2.boundary_worker_ssh](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_mount.boundary_worker_ssh](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/mount) | resource |
| [aws_instances.boundary_worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instances) | data source |
| [aws_instances.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instances) | data source |
| [aws_lb.consul_api_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lbs.consul_api_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lbs) | data source |
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
| <a name="input_create_database"></a> [create\_database](#input\_create\_database) | Create database instance | `bool` | `false` | no |
| <a name="input_create_eks_cluster"></a> [create\_eks\_cluster](#input\_create\_eks\_cluster) | Create EKS cluster | `bool` | `false` | no |
| <a name="input_database_engine"></a> [database\_engine](#input\_database\_engine) | Engine from global cluster | `string` | `null` | no |
| <a name="input_database_engine_version"></a> [database\_engine\_version](#input\_database\_engine\_version) | Engine version from global cluster | `string` | `null` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Database name to create in instance | `string` | `null` | no |
| <a name="input_global_cluster_id"></a> [global\_cluster\_id](#input\_global\_cluster\_id) | RDS global cluster ID | `string` | `null` | no |
| <a name="input_hcp_hvn_cidr_block"></a> [hcp\_hvn\_cidr\_block](#input\_hcp\_hvn\_cidr\_block) | CIDR block of the HCP HVN. | `string` | n/a | yes |
| <a name="input_is_database_primary"></a> [is\_database\_primary](#input\_is\_database\_primary) | Database is the primary instance | `bool` | `false` | no |
| <a name="input_keypair"></a> [keypair](#input\_keypair) | Keypair | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of regional resources | `string` | n/a | yes |
| <a name="input_public_subdomain_name"></a> [public\_subdomain\_name](#input\_public\_subdomain\_name) | Public Subdomain name of runtime.  i.e. eks.hashidemo.com | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region to deploy the transit gateway to.  Only used for naming purposes. | `string` | n/a | yes |
| <a name="input_remote_access"></a> [remote\_access](#input\_remote\_access) | Allow SSH access to initial node group | <pre>list(object({<br>    ec2_ssh_key               = string<br>    source_security_group_ids = list(string)<br>  }))</pre> | `null` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Runtime | `string` | `"eks"` | no |
| <a name="input_shared_services_cidr_block"></a> [shared\_services\_cidr\_block](#input\_shared\_services\_cidr\_block) | CIDR block of the shared services sandbox. | `string` | n/a | yes |
| <a name="input_subdomain_zone_id"></a> [subdomain\_zone\_id](#input\_subdomain\_zone\_id) | Zone ID of the subdomain route53 hosted zone | `string` | n/a | yes |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | transit gateway ID to point traffic to for shared services, hcp, etc. | `string` | n/a | yes |
| <a name="input_vault_address"></a> [vault\_address](#input\_vault\_address) | Vault cluster address | `string` | `null` | no |
| <a name="input_vault_namespace"></a> [vault\_namespace](#input\_vault\_namespace) | Vault cluster namespace | `string` | `null` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | Cidr block for the VPC.  Using a /22 Subnet Mask for this project is recommended. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_boundary_worker_security_group_id"></a> [boundary\_worker\_security\_group\_id](#output\_boundary\_worker\_security\_group\_id) | Boundary worker security group ID |
| <a name="output_certificate_arn"></a> [certificate\_arn](#output\_certificate\_arn) | ARN of certificate for load balancer |
| <a name="output_database"></a> [database](#output\_database) | Database attributes |
| <a name="output_database_kms_key_id"></a> [database\_kms\_key\_id](#output\_database\_kms\_key\_id) | Database KMS key ID |
| <a name="output_database_security_group_id"></a> [database\_security\_group\_id](#output\_database\_security\_group\_id) | Database security group ID |
| <a name="output_irsa"></a> [irsa](#output\_irsa) | EKS IRSA attributes for AWS LB controller |
| <a name="output_keypair_name"></a> [keypair\_name](#output\_keypair\_name) | Boundary worker keypair |
| <a name="output_ssh_private_key"></a> [ssh\_private\_key](#output\_ssh\_private\_key) | Boundary worker SSH key |
