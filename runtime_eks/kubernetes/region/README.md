# Deploying Resources to a Region

This module deploys common regional resources across AWS regions.

It creates the following resources:

- Consul Helm chart
- Vault Helm chart
- AWS Load Balancer controller

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.23 |
| <a name="requirement_hcp"></a> [hcp](#requirement\_hcp) | >= 0.76 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.7 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.13 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 3.22 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_hcp"></a> [hcp](#provider\_hcp) | >= 0.76 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.7 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.13 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.consul_client](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.lbc](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.vault](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.vault_operator](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.consul](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.hcp_consul_observability_credentials](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.hcp_consul_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.hcp_consul_token](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.vault_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [hcp_consul_agent_helm_config.cluster](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/data-sources/consul_agent_helm_config) | data source |
| [hcp_consul_agent_kubernetes_secret.cluster](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/data-sources/consul_agent_kubernetes_secret) | data source |
| [hcp_consul_cluster.cluster](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/data-sources/consul_cluster) | data source |
| [kubernetes_service_account.vault_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_lb_controller_helm_version"></a> [aws\_lb\_controller\_helm\_version](#input\_aws\_lb\_controller\_helm\_version) | AWS Load Balancer Controller Helm chart version | `string` | `"1.6.2"` | no |
| <a name="input_aws_lb_controller_irsa_role_arn"></a> [aws\_lb\_controller\_irsa\_role\_arn](#input\_aws\_lb\_controller\_irsa\_role\_arn) | AWS Load Balancer Controller IRSA role ARN | `string` | n/a | yes |
| <a name="input_aws_lb_controller_namespace"></a> [aws\_lb\_controller\_namespace](#input\_aws\_lb\_controller\_namespace) | AWS Load Balancer Controller namespace | `string` | `"kube-system"` | no |
| <a name="input_aws_lb_controller_service_account"></a> [aws\_lb\_controller\_service\_account](#input\_aws\_lb\_controller\_service\_account) | AWS Load Balancer Controller service account | `string` | `"aws-load-balancer-controller"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of EKS cluster | `string` | n/a | yes |
| <a name="input_consul_helm_version"></a> [consul\_helm\_version](#input\_consul\_helm\_version) | Consul Helm chart version | `string` | `"1.3.0"` | no |
| <a name="input_consul_namespace"></a> [consul\_namespace](#input\_consul\_namespace) | Kubernetes namespace for Consul | `string` | `"consul"` | no |
| <a name="input_consul_token"></a> [consul\_token](#input\_consul\_token) | Consul bootstrap token for cluster components to start | `string` | n/a | yes |
| <a name="input_hcp_consul_cluster_id"></a> [hcp\_consul\_cluster\_id](#input\_hcp\_consul\_cluster\_id) | HCP Consul cluster ID | `string` | n/a | yes |
| <a name="input_hcp_consul_observability"></a> [hcp\_consul\_observability](#input\_hcp\_consul\_observability) | HCP Consul observability credentials for telemetry collector | <pre>object({<br>    client_id     = string<br>    client_secret = string<br>    resource_id   = string<br>  })</pre> | `null` | no |
| <a name="input_hcp_vault_primary_address"></a> [hcp\_vault\_primary\_address](#input\_hcp\_vault\_primary\_address) | HCP Vault primary address | `string` | n/a | yes |
| <a name="input_kubernetes_endpoint"></a> [kubernetes\_endpoint](#input\_kubernetes\_endpoint) | Kubernetes cluster endpoint | `string` | n/a | yes |
| <a name="input_vault_helm_version"></a> [vault\_helm\_version](#input\_vault\_helm\_version) | Vault Helm chart version | `string` | `"0.26.1"` | no |
| <a name="input_vault_namespace"></a> [vault\_namespace](#input\_vault\_namespace) | Kubernetes namespace for Vault | `string` | `"vault"` | no |
| <a name="input_vault_operator_helm_version"></a> [vault\_operator\_helm\_version](#input\_vault\_operator\_helm\_version) | Secrets Store CSI Driver Helm chart version | `string` | `"0.3.4"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubernetes_ca_cert"></a> [kubernetes\_ca\_cert](#output\_kubernetes\_ca\_cert) | Kubernetes cluster CA certificate |
| <a name="output_kubernetes_token"></a> [kubernetes\_token](#output\_kubernetes\_token) | Kubernetes cluster token |
