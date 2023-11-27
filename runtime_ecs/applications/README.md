# Application Configuration

This sets up applications on the runtime.

## Details

It creates the following resources:

- Consul configuration entries
    - Sameness group (`ecs-sameness-group`) for regional failover
    - Exported services for `ecs-upstreams` and `ecs-upstream-users`
    - Intentions to allow connections to `ecs-upstreams`
      - `ecs-api` in same partition (`ecs`)