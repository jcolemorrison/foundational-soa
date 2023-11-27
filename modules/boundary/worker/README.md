# Boundary Worker

This module creates an AWS instance that registers as an HCP Boundary
self-managed worker. It uses worker-led registration to create a token
and store it in Vault.

You will need to write additional Terraform configuration to
read the token from Vault and register the worker into HCP Boundary.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.22 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.24.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_key_pair.boundary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_security_group.boundary_worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.allow_9202_worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_egress_worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [tls_private_key.boundary](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name of keypair for Boundary worker | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to add to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID for Boundary worker and security group | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_keypair_name"></a> [keypair\_name](#output\_keypair\_name) | Boundary worker keypair |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | Boundary worker security group |
| <a name="output_ssh_private_key"></a> [ssh\_private\_key](#output\_ssh\_private\_key) | Boundary worker SSH key |
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.22 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.22 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.boundary_worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.boundary_worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_instance.worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.boundary_worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.allow_9202_worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_egress_worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_boundary_cluster_id"></a> [boundary\_cluster\_id](#input\_boundary\_cluster\_id) | Boundary cluster ID | `string` | n/a | yes |
| <a name="input_keypair_name"></a> [keypair\_name](#input\_keypair\_name) | Name of AWS keypair for Boundary worker | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of keypair for Boundary worker | `string` | n/a | yes |
| <a name="input_public_subnet_id"></a> [public\_subnet\_id](#input\_public\_subnet\_id) | Public subnet ID for Boundary worker | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region for Boundary worker, used for filtering | `string` | n/a | yes |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Runtime associated with Boundary worker | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to add to resources | `map(string)` | `{}` | no |
| <a name="input_vault"></a> [vault](#input\_vault) | Vault attributes to store Boundary worker PKI key | <pre>object({<br>    address   = string<br>    namespace = string<br>    path      = string<br>    token     = string<br>  })</pre> | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID for Boundary worker and security group | `string` | n/a | yes |
| <a name="input_worker_tags"></a> [worker\_tags](#input\_worker\_tags) | Additional list of worker tags for filtering in Boundary | `list(string)` | `[]` | no |
| <a name="input_worker_upstreams"></a> [worker\_upstreams](#input\_worker\_upstreams) | A list of workers to connect to upstream. For multi-hop worker sessions. Format should be ["<upstream\_worker\_public\_addr>:9202"] | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | Instance ID for checking status |
| <a name="output_private_dns"></a> [private\_dns](#output\_private\_dns) | Private DNS for Boundary |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | Boundary worker security group |
