# Deploying Resources to a Region

This module deploys common regional resources across AWS regions.

It creates the following resources:

- VPC for the runtime
- ECS Cluster with EC2 instances
- `ecs-api`, `ecs-upstreams`, `ecs-upstream-users`  services on ECS
- Consul mesh gateway on ECS
- Boundary workers to log into ECS constainer instances
    - AWS keypair to add to workers and ECS container instances
- Boundary targets to...
  - SSH into ECS container instances

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.23 |
| <a name="requirement_boundary"></a> [boundary](#requirement\_boundary) | >= 1.1 |
| <a name="requirement_hcp"></a> [hcp](#requirement\_hcp) | ~> 0.76 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 3.22 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.23 |
| <a name="provider_boundary"></a> [boundary](#provider\_boundary) | >= 1.1 |
| <a name="provider_hcp"></a> [hcp](#provider\_hcp) | ~> 0.76 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 4.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | >= 3.22 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_boundary_ecs_hosts"></a> [boundary\_ecs\_hosts](#module\_boundary\_ecs\_hosts) | ../../modules/boundary/hosts | n/a |
| <a name="module_boundary_worker"></a> [boundary\_worker](#module\_boundary\_worker) | ../../modules/boundary/worker | n/a |
| <a name="module_ecs_api"></a> [ecs\_api](#module\_ecs\_api) | hashicorp/consul-ecs/aws//modules/mesh-task | 0.7.0 |
| <a name="module_ecs_controller"></a> [ecs\_controller](#module\_ecs\_controller) | hashicorp/consul-ecs/aws//modules/controller | 0.7.0 |
| <a name="module_ecs_upstream"></a> [ecs\_upstream](#module\_ecs\_upstream) | hashicorp/consul-ecs/aws//modules/mesh-task | 0.7.0 |
| <a name="module_ecs_upstream_users"></a> [ecs\_upstream\_users](#module\_ecs\_upstream\_users) | hashicorp/consul-ecs/aws//modules/mesh-task | 0.7.0 |
| <a name="module_mesh_gateway"></a> [mesh\_gateway](#module\_mesh\_gateway) | github.com/jcolemorrison/terraform-aws-consul-ecs//modules/gateway-task | fix-cert-iam-execution-policy |
| <a name="module_network"></a> [network](#module\_network) | ../../modules/runtime_network | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.subdomain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.subdomain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_autoscaling_group.container_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_cloudwatch_log_group.ecs_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.ecs_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.ecs_upstream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.ecs_upstream_users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.mesh_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_cluster.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.ecs_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_service.ecs_upstream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_service.ecs_upstream_users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_instance.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.boundary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_launch_template.container_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_lb.public_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.public_alb_http_80](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.public_alb_https_443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.public_alb_targets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_route53_record.subdomain_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_secretsmanager_secret.bootstrap_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.consul_ca_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.bootstrap_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.consul_ca_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.consul_client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.container_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.ecs_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.public_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.bastion_allow_22](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.bastion_allow_icmp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.bastion_allow_outbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.consul_client_allow_inbound_HCP_8301_tcp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.consul_client_allow_inbound_HCP_8301_udp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.consul_client_allow_inbound_runtimes_20000](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.consul_client_allow_inbound_runtimes_8301_tcp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.consul_client_allow_inbound_runtimes_8301_udp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.consul_client_allow_inbound_self_20000](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.consul_client_allow_inbound_self_8301](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.consul_client_allow_inbound_self_8301_udp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.consul_client_allow_outbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.container_instance_allow_alb_to_ephemeral](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.container_instance_allow_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.container_instance_allow_ssh_boundary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.container_instance_allow_ssh_test_bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ecs_api_allow_9090](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ecs_api_allow_inbound_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ecs_api_allow_outbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.public_alb_allow_443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.public_alb_allow_80](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.public_alb_allow_outbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [boundary_worker.ecs](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/worker) | resource |
| [tls_private_key.boundary](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_instances.boundary_worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instances) | data source |
| [aws_instances.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instances) | data source |
| [aws_ssm_parameter.amzn2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.ecs_optimized_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [hcp_consul_cluster.region](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/data-sources/consul_cluster) | data source |
| [vault_kv_secret_v2.boundary_worker_token_ecs](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/kv_secret_v2) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accessible_cidr_blocks"></a> [accessible\_cidr\_blocks](#input\_accessible\_cidr\_blocks) | List of CIDR blocks to point to the transit gateway in addition to the Shared Services sandbox and HCP HVN | `list(string)` | `[]` | no |
| <a name="input_api_deployment_maximum_percent"></a> [api\_deployment\_maximum\_percent](#input\_api\_deployment\_maximum\_percent) | Maximum percent relative to api\_desired\_count number of tasks for service to be considered healthy | `number` | `200` | no |
| <a name="input_api_deployment_minimum_healthy_percent"></a> [api\_deployment\_minimum\_healthy\_percent](#input\_api\_deployment\_minimum\_healthy\_percent) | Minimum percent relative to api\_desired\_count number of tasks for service to be considered healthy | `number` | `100` | no |
| <a name="input_api_desired_count"></a> [api\_desired\_count](#input\_api\_desired\_count) | Desired number of api tasks deployed to cluster | `number` | `3` | no |
| <a name="input_api_task_max_count"></a> [api\_task\_max\_count](#input\_api\_task\_max\_count) | maximum number of tasks allowed in the ECS api service | `number` | `6` | no |
| <a name="input_api_task_min_count"></a> [api\_task\_min\_count](#input\_api\_task\_min\_count) | minimum number of tasks allowed in the ECS api service | `number` | `3` | no |
| <a name="input_boundary_cluster_id"></a> [boundary\_cluster\_id](#input\_boundary\_cluster\_id) | Boundary cluster ID for workers to register | `string` | `null` | no |
| <a name="input_boundary_project_scope_id"></a> [boundary\_project\_scope\_id](#input\_boundary\_project\_scope\_id) | Boundary project scope ID for EKS runtime | `string` | n/a | yes |
| <a name="input_boundary_worker_vault_path"></a> [boundary\_worker\_vault\_path](#input\_boundary\_worker\_vault\_path) | Path in Vault for Boundary worker to store secret | `string` | `null` | no |
| <a name="input_boundary_worker_vault_token"></a> [boundary\_worker\_vault\_token](#input\_boundary\_worker\_vault\_token) | Token in Vault for Boundary worker to store secret | `string` | `null` | no |
| <a name="input_consul_admin_partition"></a> [consul\_admin\_partition](#input\_consul\_admin\_partition) | Name of regional consul admin partition | `string` | `"default"` | no |
| <a name="input_consul_bootstrap_token"></a> [consul\_bootstrap\_token](#input\_consul\_bootstrap\_token) | HCP Consul bootstrap token | `string` | n/a | yes |
| <a name="input_consul_cluster_id"></a> [consul\_cluster\_id](#input\_consul\_cluster\_id) | Consul Cluster ID | `string` | n/a | yes |
| <a name="input_consul_dataplane_image"></a> [consul\_dataplane\_image](#input\_consul\_dataplane\_image) | Consul ECS Dataplane Docker Image | `string` | `"hashicorp/consul-dataplane:1.3.0"` | no |
| <a name="input_consul_ecs_image"></a> [consul\_ecs\_image](#input\_consul\_ecs\_image) | Consul ECS Docker Image | `string` | `"hashicorp/consul-ecs:0.7.0"` | no |
| <a name="input_consul_namespace"></a> [consul\_namespace](#input\_consul\_namespace) | Namespace within the consul admin partition | `string` | `"default"` | no |
| <a name="input_consul_server_hosts"></a> [consul\_server\_hosts](#input\_consul\_server\_hosts) | Private URL to consul server hosts | `string` | n/a | yes |
| <a name="input_container_instance_profile"></a> [container\_instance\_profile](#input\_container\_instance\_profile) | ARN of IAM instance profile for container instances | `string` | n/a | yes |
| <a name="input_create_boundary_workers"></a> [create\_boundary\_workers](#input\_create\_boundary\_workers) | Create Boundary workers, one per public subnet | `bool` | `false` | no |
| <a name="input_ecs_keypair"></a> [ecs\_keypair](#input\_ecs\_keypair) | name of ec2 keypair for accessing container instances | `string` | `null` | no |
| <a name="input_ecs_service_role"></a> [ecs\_service\_role](#input\_ecs\_service\_role) | ARN of service role | `string` | n/a | yes |
| <a name="input_eks_upstream_uri"></a> [eks\_upstream\_uri](#input\_eks\_upstream\_uri) | endpoint for EKS upstream | `string` | n/a | yes |
| <a name="input_execute_command_policy"></a> [execute\_command\_policy](#input\_execute\_command\_policy) | ARN of policy document to execute commands for consul submodules | `string` | n/a | yes |
| <a name="input_hcp_hvn_cidr_block"></a> [hcp\_hvn\_cidr\_block](#input\_hcp\_hvn\_cidr\_block) | CIDR block of the HCP HVN. | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | container instance type (i.e. t3.medium) | `string` | `"t3.medium"` | no |
| <a name="input_keypair"></a> [keypair](#input\_keypair) | Keypair | `string` | `null` | no |
| <a name="input_max_container_instances"></a> [max\_container\_instances](#input\_max\_container\_instances) | Maximum number of EC2 instances for the ECS Cluster. | `number` | `12` | no |
| <a name="input_max_scaling_step_size"></a> [max\_scaling\_step\_size](#input\_max\_scaling\_step\_size) | Maximum number of instances to autoscale by | `number` | `1` | no |
| <a name="input_min_container_instances"></a> [min\_container\_instances](#input\_min\_container\_instances) | Minimum number of EC2 instances for the ECS Cluster. | `number` | `9` | no |
| <a name="input_min_scaling_step_size"></a> [min\_scaling\_step\_size](#input\_min\_scaling\_step\_size) | Minimum number of instances to autoscale by | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of regional resources | `string` | n/a | yes |
| <a name="input_public_domain_name"></a> [public\_domain\_name](#input\_public\_domain\_name) | Domain name for overall architecture.  Should have a hosted zone created in AWS Route53.  Registering domain in Route53 results in a zone being created by default. i.e. 'hashidemo.com' | `string` | n/a | yes |
| <a name="input_public_subdomain_name"></a> [public\_subdomain\_name](#input\_public\_subdomain\_name) | Sub domain name for this runtime.  i.e. 'ecs' which would result in a subdomain of 'ecs.hashidemo.com' | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region to deploy the transit gateway to.  Only used for naming purposes. | `string` | n/a | yes |
| <a name="input_scaling_target_capacity_size"></a> [scaling\_target\_capacity\_size](#input\_scaling\_target\_capacity\_size) | The target number of instances to autoscale towards | `number` | `3` | no |
| <a name="input_shared_services_cidr_block"></a> [shared\_services\_cidr\_block](#input\_shared\_services\_cidr\_block) | CIDR block of the shared services sandbox. | `string` | n/a | yes |
| <a name="input_subdomain_zone_id"></a> [subdomain\_zone\_id](#input\_subdomain\_zone\_id) | Route53 Hosted Zone ID for the subdomain | `string` | n/a | yes |
| <a name="input_test_bastion_cidr_blocks"></a> [test\_bastion\_cidr\_blocks](#input\_test\_bastion\_cidr\_blocks) | test bastion cidr blocks | `list(string)` | `[]` | no |
| <a name="input_test_bastion_enabled"></a> [test\_bastion\_enabled](#input\_test\_bastion\_enabled) | whether or not to deploy a test bastion | `bool` | `false` | no |
| <a name="input_test_bastion_keypair"></a> [test\_bastion\_keypair](#input\_test\_bastion\_keypair) | test bastion keypair | `string` | `null` | no |
| <a name="input_test_failover"></a> [test\_failover](#input\_test\_failover) | whether or not to trigger failover | `bool` | `false` | no |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | transit gateway ID to point traffic to for shared services, hcp, etc. | `string` | n/a | yes |
| <a name="input_upstream_deployment_maximum_percent"></a> [upstream\_deployment\_maximum\_percent](#input\_upstream\_deployment\_maximum\_percent) | Maximum percent relative to upstream\_desired\_count number of tasks for service to be considered healthy | `number` | `200` | no |
| <a name="input_upstream_deployment_minimum_healthy_percent"></a> [upstream\_deployment\_minimum\_healthy\_percent](#input\_upstream\_deployment\_minimum\_healthy\_percent) | Minimum percent relative to upstream\_desired\_count number of tasks for service to be considered healthy | `number` | `100` | no |
| <a name="input_upstream_desired_count"></a> [upstream\_desired\_count](#input\_upstream\_desired\_count) | Desired number of upstream tasks deployed to cluster | `number` | `3` | no |
| <a name="input_upstream_task_max_count"></a> [upstream\_task\_max\_count](#input\_upstream\_task\_max\_count) | maximum number of tasks allowed in the ECS upstream service | `number` | `6` | no |
| <a name="input_upstream_task_min_count"></a> [upstream\_task\_min\_count](#input\_upstream\_task\_min\_count) | minimum number of tasks allowed in the ECS upstream service | `number` | `3` | no |
| <a name="input_vault_address"></a> [vault\_address](#input\_vault\_address) | Vault cluster address | `string` | `null` | no |
| <a name="input_vault_namespace"></a> [vault\_namespace](#input\_vault\_namespace) | Vault cluster namespace | `string` | `null` | no |
| <a name="input_vault_secrets_namespace"></a> [vault\_secrets\_namespace](#input\_vault\_secrets\_namespace) | Namespace used for Vault secrets for ECS | `string` | n/a | yes |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | Cidr block for the VPC.  Using a /22 Subnet Mask for this project is recommended. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_keypair_name"></a> [keypair\_name](#output\_keypair\_name) | Boundary worker keypair |
| <a name="output_public_alb_dns_values"></a> [public\_alb\_dns\_values](#output\_public\_alb\_dns\_values) | DNS Name and Zone ID of regional public application load balancer for the ECS API |
| <a name="output_ssh_private_key"></a> [ssh\_private\_key](#output\_ssh\_private\_key) | Boundary worker SSH key |
