#!/bin/bash

terraform apply -replace='module.us_east_1.module.boundary_worker[0].aws_instance.worker'
terraform apply -replace='module.us_west_2.module.boundary_worker[0].aws_instance.worker'
terraform apply -replace='module.eu_west_1.module.boundary_worker[0].aws_instance.worker'

terraform apply -replace='module.us_east_1.boundary_worker.eks[0]'
terraform apply -replace='module.us_west_2.boundary_worker.eks[0]'
terraform apply -replace='module.eu_west_1.boundary_worker.eks[0]'