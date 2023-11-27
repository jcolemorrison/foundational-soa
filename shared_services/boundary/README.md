# Shared Services Sandbox (AWS Account) - Boudnary

Terraform configuration creates resources for Boundary.

You must run workspaces in the following order:

- `shared-services`
- `shared-services-vault`
- `shared-services-boundary`
- `shared-services-consul`
- `shared-services-dns`

## Details

- Boundary scopes

## Terraform Cloud

Name: `shared-services-boundary`

- VCS
  - Working directory: `shared_services/boundary`