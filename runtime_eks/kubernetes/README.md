# EKS Runtime Sandbox (AWS Account) - Kubernetes Deployments

Terraform configuration that deploys Kubernetes Helm charts on EKS.

You must run workspaces in the following order:

- `runtime-eks`
- `runtime-eks-kubernetes`
- `runtime-eks-applications`

## Details

- Consul Helm chart (`consul` namespace)
- Vault Helm chart (`vault` namespace)
- Vault Secrets Operator Helm chart (`vault` namespace)
- AWS Load Balancer Controller Helm chart (`kube-system` namespace)
- Vault Kubernetes authentication method

 ## Terraform Cloud

 Name: `runtime-eks-kubernetes`

 - Workspace variables
   - `TFC_AWS_PROVIDER_AUTH = true`
   - `TFC_AWS_RUN_ROLE_ARN = <role in AWS that generates dynamic access keys`
   - `hcp_consul_observability` - These are credentials for the telemetry collector on HCP.
- Variable sets
  - HCP Credentials
  - `terraform_cloud_organization`
- VCS
  - Working directory: `runtime_eks/kubernetes`
- Remote state sharing
  - `runtime-eks-applications`

## Caveats

- Telemetry collector and API gateway are disabled due to issues with use of admin partitions