# ECS Runtime Sandbox (AWS Account)

Terraform configuration creates resources for the ECS runtime.

## Details

 - Consul partition: `ecs`
 - Boundary scope: `runtime_ecs`
    - Targets: SSH into ECS container instances
 - Vault
    - Namespace: `prod-ecs`
    - Secrets:
      - API keys in key-value store
 - Services:
    - `ecs-api` service accesses `ecs-upstream` service
    - `ecs-api` service access `store` running on EKS

 ## Terraform Cloud

 Name: `runtime-ecs`

 - Workspace variables
   - `TFC_AWS_PROVIDER_AUTH = true`
   - `TFC_AWS_RUN_ROLE_ARN = <role in AWS that generates dynamic access keys`
   - `public_domain_name` - public domain name to attach to services
   - `public_subdomain_name` - subdomain mane
- Variable sets
  - HCP credentials
  - `terraform_cloud_organization`
- VCS
  - Working directory: `runtime_ecs`
- Remote state sharing
  - `shared_services_dns`