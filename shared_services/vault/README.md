# Shared Services Sandbox (AWS Account) - Vault

Terraform configuration creates resources for Vault.

You must run workspaces in the following order:

- `shared-services`
- `shared-services-vault`
- `shared-services-boundary`
- `shared-services-consul`
- `shared-services-dns`

## Details

This repository creates the following Vault configurations.

- Boundary worker namespace and secrets mounts.
- Consul CA namespace and secrets mounts.

## Terraform Cloud

Name: `shared-services-vault`

- Workspace variables
  -  `certificate_common_name` - certificate common name
  - `TFC_AWS_PROVIDER_AUTH = true`
  - `TFC_AWS_RUN_ROLE_ARN = <role in AWS that generates dynamic access keys`
  - `public_subdomain_name` - subdomain mane
- Variable sets
  - `terraform_cloud_organization`
- VCS
  - Working directory: `shared_services/vault`