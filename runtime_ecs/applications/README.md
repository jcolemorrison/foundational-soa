# Application Configuration

This sets up applications on the runtime.

## Details

It creates the following resources:

- Consul configuration entries
    - Sameness group (`ecs-sameness-group`) for regional failover
    - Exported services for `ecs-upstreams` and `ecs-upstream-users`
    - Intentions to allow connections to `ecs-upstreams`
      - `ecs-api` in same partition (`ecs`)

 ## Terraform Cloud

 Name: `runtime-ecs-applications`

- Workspace variables: N/A
- Variable sets
  - HCP credentials
  - `terraform_cloud_organization`
- VCS
  - Working directory: `runtime_ecs/applications`
- Remote state sharing: N/A