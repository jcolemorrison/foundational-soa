# EKS Cluster

Terraform module creates EKS cluster and node groups.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.22 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.22 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_eks_addon.vpc_cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.node_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_openid_connect_provider.oidc_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.cluster_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.lb_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.irsa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cluster_additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cluster_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.irsa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_group_additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.consul_mesh_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.consul_mesh_gateway_envoy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.consul_mesh_gateway_wan](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.consul_tcp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.consul_udp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role_policy_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.assume_role_policy_node_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_session_context.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_session_context) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [tls_certificate.cluster](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accessible_cidr_blocks"></a> [accessible\_cidr\_blocks](#input\_accessible\_cidr\_blocks) | List of routable CIDR blocks to allow Consul proxies to connect | `list(string)` | `[]` | no |
| <a name="input_cluster_additional_security_group_ids"></a> [cluster\_additional\_security\_group\_ids](#input\_cluster\_additional\_security\_group\_ids) | Additional cluster security group IDs | `list(string)` | `[]` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Cluster Kubernetes version. If not defined, latest available at creation | `string` | `null` | no |
| <a name="input_eks_cluster_iam_role_additional_policies"></a> [eks\_cluster\_iam\_role\_additional\_policies](#input\_eks\_cluster\_iam\_role\_additional\_policies) | Additional IAM policies for EKS cluster role | `map(string)` | `{}` | no |
| <a name="input_enable_default_eks_policy"></a> [enable\_default\_eks\_policy](#input\_enable\_default\_eks\_policy) | Enable default EKS policy | `bool` | `true` | no |
| <a name="input_endpoint_private_access"></a> [endpoint\_private\_access](#input\_endpoint\_private\_access) | Private API server endpoint is enabled | `bool` | `true` | no |
| <a name="input_endpoint_public_access"></a> [endpoint\_public\_access](#input\_endpoint\_public\_access) | Public API server endpoint is enabled | `bool` | `true` | no |
| <a name="input_hcp_network_cidr_block"></a> [hcp\_network\_cidr\_block](#input\_hcp\_network\_cidr\_block) | HCP network CIDR block for connection to HCP Consul | `string` | n/a | yes |
| <a name="input_key_owners"></a> [key\_owners](#input\_key\_owners) | Owners of key allowed for all KMS key operations | `list(string)` | `[]` | no |
| <a name="input_key_users"></a> [key\_users](#input\_key\_users) | Users of key allowed to encrypt/decrypt with KMS key for cluster | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of EKS cluster | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace of valid service account for IAM roles to authenticate to EKS | `string` | `"kube-system"` | no |
| <a name="input_node_group_config"></a> [node\_group\_config](#input\_node\_group\_config) | Node group configuration | <pre>object({<br>    min_size        = number<br>    max_size        = number<br>    desired_size    = number<br>    instance_types  = list(string)<br>    labels          = map(string)<br>    max_unavailable = number<br>    capacity_type   = string<br>    ami_type        = string<br>    disk_size       = string<br>  })</pre> | <pre>{<br>  "ami_type": "AL2_x86_64",<br>  "capacity_type": "ON_DEMAND",<br>  "desired_size": 3,<br>  "disk_size": 30,<br>  "instance_types": null,<br>  "labels": null,<br>  "max_size": 5,<br>  "max_unavailable": 1,<br>  "min_size": 1<br>}</pre> | no |
| <a name="input_node_group_iam_role_additional_policies"></a> [node\_group\_iam\_role\_additional\_policies](#input\_node\_group\_iam\_role\_additional\_policies) | Additional IAM policies for node group role | `map(string)` | `{}` | no |
| <a name="input_node_security_group_additional_rules"></a> [node\_security\_group\_additional\_rules](#input\_node\_security\_group\_additional\_rules) | Additional rules for main node group | `map(string)` | `{}` | no |
| <a name="input_path_prefix"></a> [path\_prefix](#input\_path\_prefix) | Path prefix for EKS cluster CloudWatch log group | `string` | `"/aws/eks"` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | List of private subnet IDs, at least in two different availability zones | `list(string)` | n/a | yes |
| <a name="input_remote_access"></a> [remote\_access](#input\_remote\_access) | Enable remote access to node groups | <pre>object({<br>    ec2_ssh_key               = string<br>    source_security_group_ids = list(string)<br>  })</pre> | `null` | no |
| <a name="input_service_account"></a> [service\_account](#input\_service\_account) | Name of valid service account for IAM roles to authenticate to EKS | `string` | `"aws-load-balancer-controller"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags for EKS cluster | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID of EKS cluster | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_security_group"></a> [eks\_cluster\_security\_group](#output\_eks\_cluster\_security\_group) | Primary EKS cluster security group |
| <a name="output_irsa"></a> [irsa](#output\_irsa) | IAM Role service account information for AWS LB Controller |
