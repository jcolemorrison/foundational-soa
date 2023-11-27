# Frontend Runtime Sandbox (AWS Account)

Terraform configuration creates resources for the frontend application.

This is deployed in the default region, `us-east-1`.

## Details

 - Certificate from ACM
 - Route 53 configuration
 - Cloudfront
 - S3 Bucket

 ## Terraform Cloud

 Name: `runtime-frontend`

 - Workspace variables
   - `TFC_AWS_PROVIDER_AUTH = true`
   - `TFC_AWS_RUN_ROLE_ARN = <role in AWS that generates dynamic access keys`
   - `subdomain_name` - subdomain mane
- Variable sets
  - `terraform_cloud_organization`
- VCS
  - Working directory: `runtime_frontend`
- Remote state sharing
  - `shared-services-dns`