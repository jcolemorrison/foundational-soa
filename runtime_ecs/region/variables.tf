# Network Specific Variables
variable "vpc_cidr_block" {
  type        = string
  description = "Cidr block for the VPC.  Using a /22 Subnet Mask for this project is recommended."
}

variable "region" {
  type        = string
  description = "AWS region to deploy the transit gateway to.  Only used for naming purposes."
}

variable "transit_gateway_id" {
  type = string
  description = "transit gateway ID to point traffic to for shared services, hcp, etc."
}

variable "shared_services_cidr_block" {
  type = string
  description = "CIDR block of the shared services sandbox."
}

variable "hcp_hvn_cidr_block" {
  type = string
  description = "CIDR block of the HCP HVN."
}

variable "accessible_cidr_blocks" {
  type = list(string)
  description = "List of CIDR blocks to point to the transit gateway in addition to the Shared Services sandbox and HCP HVN"
  default = []
}

# EC2 Variables
variable "ecs_keypair" {
  type = string
  description = "name of ec2 keypair for accessing container instances"
  default = null
}

variable "container_instance_profile" {
  type = string
  description = "ARN of IAM instance profile for container instances"
}

variable "instance_type" {
  type = string
  description = "container instance type (i.e. t3.medium)"
  default = "t3.medium"
}

variable "name" {
  type        = string
  description = "Name of regional resources"
}

variable "max_container_instances" {
  type = number
  description = "Maximum number of EC2 instances for the ECS Cluster."
  default = 3
}

variable "min_container_instances" {
  type = number
  description = "Minimum number of EC2 instances for the ECS Cluster."
  default = 3
}

variable "min_scaling_step_size" {
  type = number
  description = "Minimum number of instances to autoscale by"
  default = 1
}

variable "max_scaling_step_size" {
  type = number
  description = "Maximum number of instances to autoscale by"
  default = 1
}

variable "scaling_target_capacity_size" {
  type = number
  description = "The target number of instances to autoscale towards"
  default = 3
}

## ECS

variable "ecs_service_role" {
  type = string
  description = "ARN of service role"
}

variable "execute_command_policy" {
  type = string
  description = "ARN of policy document to execute commands for consul submodules"
}

variable "api_desired_count" {
  type = number
  description = "Desired number of api tasks deployed to cluster"
  default = 3
}

variable "api_deployment_minimum_healthy_percent" {
  type = number
  description = "Minimum percent relative to api_desired_count number of tasks for service to be considered healthy"
  default = 100
}

variable "api_deployment_maximum_percent" {
  type = number
  description = "Maximum percent relative to api_desired_count number of tasks for service to be considered healthy"
  default = 300
}

variable "api_task_max_count" {
  type = number
  description = "maximum number of tasks allowed in the ECS api service"
  default = 6
}

variable "api_task_min_count" {
  type = number
  description = "minimum number of tasks allowed in the ECS api service"
  default = 3
}

variable "upstream_desired_count" {
  type = number
  description = "Desired number of upstream tasks deployed to cluster"
  default = 3
}

variable "upstream_deployment_minimum_healthy_percent" {
  type = number
  description = "Minimum percent relative to upstream_desired_count number of tasks for service to be considered healthy"
  default = 100
}

variable "upstream_deployment_maximum_percent" {
  type = number
  description = "Maximum percent relative to upstream_desired_count number of tasks for service to be considered healthy"
  default = 300
}

variable "upstream_task_max_count" {
  type = number
  description = "maximum number of tasks allowed in the ECS upstream service"
  default = 6
}

variable "upstream_task_min_count" {
  type = number
  description = "minimum number of tasks allowed in the ECS upstream service"
  default = 3
}

## Route53

variable "public_domain_name" {
  type = string
  description = "Domain name for overall architecture.  Should have a hosted zone created in AWS Route53.  Registering domain in Route53 results in a zone being created by default. i.e. 'hashidemo.com'"
}

variable "public_subdomain_name" {
  type = string
  description = "Sub domain name for this runtime.  i.e. 'ecs' which would result in a subdomain of 'ecs.hashidemo.com'"
}

variable "subdomain_zone_id" {
  type = string
  description = "Route53 Hosted Zone ID for the subdomain"
}

## Consul

variable "consul_public_address" {
  type = string
  description = "HCP Consul public address"
}

variable "consul_bootstrap_token" {
  type = string
  description = "HCP Consul bootstrap token"
}

variable "consul_ecs_image" {
  type = string
  description = "Consul ECS Docker Image"
  default = "hashicorp/consul-ecs:0.7.0"
}

variable "consul_dataplane_image" {
  type = string
  description = "Consul ECS Dataplane Docker Image"
  default = "hashicorp/consul-dataplane:1.3.0"
}

variable "consul_server_hosts" {
  type = string
  description = "Private URL to consul server hosts"
}

variable "consul_admin_partition" {
  type = string
  description = "Name of regional consul admin partition"
  default = "default"
}

variable "consul_namespace" {
  type = string
  description = "Namespace within the consul admin partition"
  default = "default"
}

variable "consul_cluster_id" {
  type = string
  description = "Consul Cluster ID"
}

## Boundary workers

variable "create_boundary_workers" {
  type        = bool
  description = "Create Boundary workers, one per public subnet"
  default     = false
}

variable "keypair" {
  type        = string
  description = "Keypair"
  default     = null
}

variable "vault_address" {
  type        = string
  description = "Vault cluster address"
  default     = null
}

variable "vault_namespace" {
  type        = string
  description = "Vault cluster namespace"
  default     = null
}

variable "boundary_worker_vault_path" {
  type        = string
  description = "Path in Vault for Boundary worker to store secret"
  default     = null
}

variable "boundary_worker_vault_token" {
  type        = string
  description = "Token in Vault for Boundary worker to store secret"
  sensitive   = true
  default     = null
}

variable "boundary_cluster_id" {
  type        = string
  description = "Boundary cluster ID for workers to register"
  default     = null
}

variable "boundary_project_scope_id" {
  type        = string
  description = "Boundary project scope ID for EKS runtime"
}

## Test Bastion

variable "test_bastion_enabled" {
  type = bool
  description = "whether or not to deploy a test bastion"
  default = false
}

variable "test_bastion_keypair" {
  type = string
  description = "test bastion keypair"
  default = null
}

variable "test_bastion_cidr_blocks" {
  type = list(string)
  description = "test bastion cidr blocks"
  default = []
}