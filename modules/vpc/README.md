# VPC Module

Notes:

Each top level sandbox can occupy a /16, with /22 subnets being used for the regional VPCs.  This allows for 255 sandboxes with each allowing for 64 individual VPCs with 1022 hosts available that can be further divided into 8 subnets with 126 hosts available.

i.e.

```
shared_services (reserves 10.0.0.0/16)
  region_us_east_1 VPC (occupies 10.0.0.0/22)
  region_us_east_1 transit gateway (occupies 10.0.4.0/22)

  region_us_west_2 VPC (occupies 10.0.8.0/22)
  region_us_west_2 transit gateway (occupies 10.0.12.0/22)

  region_eu_west_1 VPC (occupies 10.0.16.0/22)
  region_eu_west_1 transit gateway (occupies 10.0.20.0/22)

runtime_ec2 (reserves 10.1.0.0/16)
  region_us_east_1 VPC (occupies 10.1.0.0/22)
  region_us_west_2 VPC (occupies 10.1.4.0/22)
  region_eu_west_1 VPC (occupies 10.1.8.0/22)

runtime_ecs (reserves 10.2.0.0/16)
  region_us_east_1 VPC (occupies 10.2.0.0/22)
  region_us_west_2 VPC (occupies 10.2.4.0/22)
  region_eu_west_1 VPC (occupies 10.2.8.0/22)

runtime_eks (reserves 10.3.0.0/16)
  region_us_east_1 VPC (occupies 10.3.0.0/22)
  region_us_west_2 VPC (occupies 10.3.4.0/22)
  region_eu_west_1 VPC (occupies 10.3.8.0/22)

runtime_frontend (reserves 10.4.0.0/16)
  region_us_east_1 VPC (occupies 10.4.0.0/22)
  region_us_west_2 VPC (occupies 10.4.4.0/22)
  region_eu_west_1 VPC (occupies 10.4.8.0/22)
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.23.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.23.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_egress_only_internet_gateway.eigw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/egress_only_internet_gateway) | resource |
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.private_internet_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.private_internet_access_ipv6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public_internet_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | Cidr block for the VPC.  Using a /22 Subnet Mask for this project is recommended. | `string` | n/a | yes |
| <a name="input_instance_tenancy"></a> [instance\_tenancy](#input\_instance\_tenancy) | Tenancy for instances launched into the VPC. | `string` | `"default"` | no |
| <a name="input_ipv6_enabled"></a> [ipv6\_enabled](#input\_ipv6\_enabled) | Whether or not to enable IPv6 support in the VPC. | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name use across all resources related to this VPC | `string` | n/a | yes |
| <a name="input_private_subnet_count"></a> [private\_subnet\_count](#input\_private\_subnet\_count) | The number of private subnets to create.  Cannot exceed the number of AZs in your selected region. | `number` | `3` | no |
| <a name="input_public_subnet_count"></a> [public\_subnet\_count](#input\_public\_subnet\_count) | The number of public subnets to create.  Cannot exceed the number of AZs in your selected region. | `number` | `3` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tags for AWS resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the VPC |
| <a name="output_cidr_block"></a> [cidr\_block](#output\_cidr\_block) | IPv4 CIDR block of the VPC |
| <a name="output_id"></a> [id](#output\_id) | ID of the VPC |
| <a name="output_ipv6_cidr_block"></a> [ipv6\_cidr\_block](#output\_ipv6\_cidr\_block) | IPv6 CIDR block of the VPC |
| <a name="output_private_route_table_id"></a> [private\_route\_table\_id](#output\_private\_route\_table\_id) | ID of the VPC's private route table |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | List of private subnet IDs |
| <a name="output_public_route_table_id"></a> [public\_route\_table\_id](#output\_public\_route\_table\_id) | ID of the VPC's public route table |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | List of public subnet IDs |
