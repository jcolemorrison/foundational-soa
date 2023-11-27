# Runtime Network Module

Includes a VPC and attachments / routes for Shared Services and HCP HVNs.  A wrapper for the VPC module for each runtime.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.23.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.23.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_vpc_attachment.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_route.hcp_hvn_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.hcp_hvn_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.runtime_route_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.runtime_route_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.shared_services_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.shared_services_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accessible_cidr_blocks"></a> [accessible\_cidr\_blocks](#input\_accessible\_cidr\_blocks) | List of CIDR blocks to point to the transit gateway in addition to the Shared Services sandbox and HCP HVN | `list(string)` | `[]` | no |
| <a name="input_attach_public_subnets"></a> [attach\_public\_subnets](#input\_attach\_public\_subnets) | Attach public subnets instead of private subnets to transit gateway | `bool` | `true` | no |
| <a name="input_hcp_hvn_cidr_block"></a> [hcp\_hvn\_cidr\_block](#input\_hcp\_hvn\_cidr\_block) | CIDR block of the HCP HVN. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region to deploy the transit gateway to.  Only used for naming purposes. | `string` | n/a | yes |
| <a name="input_shared_services_cidr_block"></a> [shared\_services\_cidr\_block](#input\_shared\_services\_cidr\_block) | CIDR block of the shared services sandbox. | `string` | n/a | yes |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | transit gateway ID to point traffic to for shared services, hcp, etc. | `string` | n/a | yes |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | Cidr block for the VPC.  Using a /22 Subnet Mask for this project is recommended. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_transit_gateway_vpc_attachment_id"></a> [transit\_gateway\_vpc\_attachment\_id](#output\_transit\_gateway\_vpc\_attachment\_id) | ID of the transit gateway VPC attachment |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | ARN of the VPC |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | IPv4 CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID of the VPC |
| <a name="output_vpc_ipv6_cidr_block"></a> [vpc\_ipv6\_cidr\_block](#output\_vpc\_ipv6\_cidr\_block) | IPv6 CIDR block of the VPC |
| <a name="output_vpc_private_route_table_id"></a> [vpc\_private\_route\_table\_id](#output\_vpc\_private\_route\_table\_id) | ID of the VPC's private route table |
| <a name="output_vpc_private_subnet_ids"></a> [vpc\_private\_subnet\_ids](#output\_vpc\_private\_subnet\_ids) | List of private subnet IDs |
| <a name="output_vpc_public_route_table_id"></a> [vpc\_public\_route\_table\_id](#output\_vpc\_public\_route\_table\_id) | ID of the VPC's public route table |
| <a name="output_vpc_public_subnet_ids"></a> [vpc\_public\_subnet\_ids](#output\_vpc\_public\_subnet\_ids) | List of public subnet IDs |
