# EC2 Runtime Sandbox (AWS Account)

Terraform configuration creates resources for the EC2 runtime.

## Details

 - Consul partition: `ec2`
 - Boundary scope: `runtime_ec2`
    - Targets: SSH into services and Consul mesh gateway
 - Vault: N/A
 - Services: `reports` service accesses `payments` service

 ## Terraform Cloud

Name: `runtime-ec2`

 - Workspace variables
   - `TFC_AWS_PROVIDER_AUTH = true`
   - `TFC_AWS_RUN_ROLE_ARN = <role in AWS that generates dynamic access keys`
- Variable sets
  - HCP credentials
  - `terraform_cloud_organization`
- VCS
  - Working directory: `runtime_ec2`
- Remote state sharing: N/A