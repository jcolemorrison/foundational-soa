# VPC Module

Notes:

Each top level sandbox can occupy a /16, with /22 subnets being used for the regional VPCs.  This allows for 255 sandboxes with each allowing for 64 individual VPCs with 1022 hosts available that can be further divided into 8 subnets with 126 hosts available.

i.e.

```
shared_services (reserves 10.0.0.0/16)
  region_us_east_1 VPC (occupies 10.0.0.0/22)
  region_us_east_1 transit gateway (occupies 10.0.4.0/22)

  region_us_west_2 VPC (occupies 10.0.8.0/22)
  region_us_west_2 transit gateway (occupies 10.0.12.0/22)

  region_eu_west_1 VPC (occupies 10.0.16.0/22)
  region_eu_west_1 transit gateway (occupies 10.0.20.0/22)

runtime_ec2 (reserves 10.1.0.0/16)
  region_us_east_1 VPC (occupies 10.1.0.0/22)
  region_us_west_2 VPC (occupies 10.1.4.0/22)
  region_eu_west_1 VPC (occupies 10.1.8.0/22)

runtime_ecs (reserves 10.2.0.0/16)
  region_us_east_1 VPC (occupies 10.2.0.0/22)
  region_us_west_2 VPC (occupies 10.2.4.0/22)
  region_eu_west_1 VPC (occupies 10.2.8.0/22)

runtime_eks (reserves 10.3.0.0/16)
  region_us_east_1 VPC (occupies 10.3.0.0/22)
  region_us_west_2 VPC (occupies 10.3.4.0/22)
  region_eu_west_1 VPC (occupies 10.3.8.0/22)

runtime_frontend (reserves 10.4.0.0/16)
  region_us_east_1 VPC (occupies 10.4.0.0/22)
  region_us_west_2 VPC (occupies 10.4.4.0/22)
  region_eu_west_1 VPC (occupies 10.4.8.0/22)
```