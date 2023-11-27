# EKS Runtime Sandbox (AWS Account) - Kubernetes Applications

Terraform configuration that deploys Kubernetes applications on EKS.

You must run workspaces in the following order:

- `runtime-eks`
- `runtime-eks-kubernetes`
- `runtime-eks-applications`

## Details

- Services (`default` namespace)
  - store
  - customers
  - database
- Kubernetes authentication method in Vault

 ## Terraform Cloud

 Name: `runtime-eks-applications`

 - Workspace variables
   - `TFC_AWS_PROVIDER_AUTH = true`
   - `TFC_AWS_RUN_ROLE_ARN = <role in AWS that generates dynamic access keys`
- Variable sets
  - `terraform_cloud_organization`
- VCS
  - Working directory: `runtime_eks/kubernetes`
- Remote state sharing
  - `runtime-eks-applicatios`