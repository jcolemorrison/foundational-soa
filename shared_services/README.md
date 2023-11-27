# Shared Services Sandbox (AWS Account)

Terraform configuration creates resources for shared services.

You must run workspaces in the following order:

- `shared-services`
- `shared-services-vault`
- `shared-services-boundary`
- `shared-services-consul`
- `shared-services-dns`

## Details

- Shared VPC
- HCP cluster

## Terraform Cloud

Name: `shared-services`

- Workspace variables
  - `TFC_AWS_PROVIDER_AUTH = true`
  - `TFC_AWS_RUN_ROLE_ARN = <role in AWS that generates dynamic access keys`
- Variable sets
  - HCP Credentials
- VCS
  - Working directory: `shared_services`
- Remote state sharing
  - global