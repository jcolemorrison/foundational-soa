# Shared Services Sandbox (AWS Account) - Consul

Terraform configuration creates resources for Consul.

You must run workspaces in the following order:

- `shared-services`
- `shared-services-vault`
- `shared-services-boundary`
- `shared-services-consul`
- `shared-services-dns`

## Details

This repository creates the following Consul configuration
entries.

- Proxy defeaults
- Peering
- Partitions
- Service mesh certificate configuration
- Default intentions

Consul is peered by each partition across regions.
Each partition represents a runtime.

- `default` - EKS
- `ecs` - ECS
- `ec2` - EC2

## Terraform Cloud

Name: `shared-services-boundary`

- VCS
  - Working directory: `shared_services/consul`