# Fake-Service on EC2 Instance

Deploys fake-service on an EC2 instance with a Consul client. You can customize
the name and message of the service.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.23 |
| <a name="requirement_hcp"></a> [hcp](#requirement\_hcp) | >= 0.76 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.26.0 |
| <a name="provider_hcp"></a> [hcp](#provider\_hcp) | 0.77.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [hcp_consul_cluster.cluster](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/data-sources/consul_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_fake_service_message"></a> [fake\_service\_message](#input\_fake\_service\_message) | Message to pass to fake-service | `string` | n/a | yes |
| <a name="input_fake_service_name"></a> [fake\_service\_name](#input\_fake\_service\_name) | Name to pass to fake-service | `string` | n/a | yes |
| <a name="input_fake_service_port"></a> [fake\_service\_port](#input\_fake\_service\_port) | Message to pass to fake-service | `string` | `9090` | no |
| <a name="input_hcp_consul_cluster_id"></a> [hcp\_consul\_cluster\_id](#input\_hcp\_consul\_cluster\_id) | HCP Consul cluster ID | `string` | n/a | yes |
| <a name="input_hcp_consul_cluster_token"></a> [hcp\_consul\_cluster\_token](#input\_hcp\_consul\_cluster\_token) | Consul bootstrap token for clients to start | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type | `string` | `"t2.small"` | no |
| <a name="input_key_pair_name"></a> [key\_pair\_name](#input\_key\_pair\_name) | Name of key pair attached to Boundary worker to add to application on VM | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name used for VMs and other resources | `string` | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security groups to attach to instance | `list(string)` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID of subnet to create instance | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to include with resources | `map(string)` | `{}` | no |
| <a name="input_upstream_service_local_bind_port"></a> [upstream\_service\_local\_bind\_port](#input\_upstream\_service\_local\_bind\_port) | Local port to bind to access upstream service | `number` | `9091` | no |
| <a name="input_upstream_service_name"></a> [upstream\_service\_name](#input\_upstream\_service\_name) | Upstream service name | `string` | `null` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | CIDR block for VPC | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of VPC for instance | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ip_address"></a> [ip\_address](#output\_ip\_address) | IP address of instance |
