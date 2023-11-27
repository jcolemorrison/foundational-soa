# EKS Runtime Sandbox (AWS Account)

Terraform configuration creates resources for the EKS runtime.

You must run workspaces in the following order:

- `runtime-eks`
- `runtime-eks-kubernetes`
- `runtime-eks-applications`

## Details

 - Consul partition: `default`
   - EKS primary deployment configuration is optimal in `default` partition
 - Boundary scope: `runtime_eks`
    - Targets:
      - SSH into EKS nodes
      - RDS database instance
 - Vault
    - Namespace: `prod` (for database)
     - Secrets:
      - Database admin credentials in key-value store
      - Database read credentials in database secrets engine
 - Services:
    - `store` service accesses `customer` service
    - `customer` service accesses `database` service

 ## Terraform Cloud

 Name: `runtime-eks`

 - Workspace variables
   - `TFC_AWS_PROVIDER_AUTH = true`
   - `TFC_AWS_RUN_ROLE_ARN = <role in AWS that generates dynamic access keys`
   - `public_subdomain_name` - subdomain mane
- Variable sets
  - `terraform_cloud_organization`
- VCS
  - Working directory: `runtime_eks`
- Remote state sharing
  - `shared-services-dns`
  - `runtime-eks-kubernetes`
  - `runtime-eks-applicatios`