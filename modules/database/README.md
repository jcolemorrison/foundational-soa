# Amazon RDS Database

This module configures a databse cluster and cluster instance
that registers with a global cluster in Amazon RDS.

The primary replica is usually the first one created and
added to the global cluster. However, you'll need to
define it in this module to generate a username
and password.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.22 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.26.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_subnet_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_rds_cluster.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_security_group.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.allow_database_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_database_from_boundary_worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_database_from_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [random_password.database](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_pet.database](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accessible_cidr_blocks"></a> [accessible\_cidr\_blocks](#input\_accessible\_cidr\_blocks) | List of routable CIDR blocks to allow Consul proxies to connect | `list(string)` | `[]` | no |
| <a name="input_boundary_worker_security_group_id"></a> [boundary\_worker\_security\_group\_id](#input\_boundary\_worker\_security\_group\_id) | Boundary worker security group ID | `string` | n/a | yes |
| <a name="input_database_engine"></a> [database\_engine](#input\_database\_engine) | Engine from global cluster | `string` | n/a | yes |
| <a name="input_database_engine_version"></a> [database\_engine\_version](#input\_database\_engine\_version) | Engine version from global cluster | `string` | n/a | yes |
| <a name="input_database_port"></a> [database\_port](#input\_database\_port) | Database port | `number` | `5432` | no |
| <a name="input_db_instance_class"></a> [db\_instance\_class](#input\_db\_instance\_class) | Database instance class | `string` | `"db.r6i.large"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Database name to create in instance | `string` | n/a | yes |
| <a name="input_global_cluster_id"></a> [global\_cluster\_id](#input\_global\_cluster\_id) | RDS global cluster ID | `string` | n/a | yes |
| <a name="input_hcp_network_cidr_block"></a> [hcp\_network\_cidr\_block](#input\_hcp\_network\_cidr\_block) | HCP network CIDR block for connection to HCP Vault and Consul | `string` | n/a | yes |
| <a name="input_is_primary"></a> [is\_primary](#input\_is\_primary) | Database is the primary instance | `bool` | `false` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | List of private subnet IDs, at least in two different availability zones | `list(string)` | n/a | yes |
| <a name="input_service"></a> [service](#input\_service) | Name of service to identify instance | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_address"></a> [address](#output\_address) | Address of database |
| <a name="output_dbname"></a> [dbname](#output\_dbname) | Database name created in managed instance |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS Key ID for storage encryption |
| <a name="output_password"></a> [password](#output\_password) | Password of database |
| <a name="output_port"></a> [port](#output\_port) | Port of database |
| <a name="output_read_only_address"></a> [read\_only\_address](#output\_read\_only\_address) | Read-only address for a reader replica |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | Security group ID for database |
| <a name="output_username"></a> [username](#output\_username) | Username of database |
