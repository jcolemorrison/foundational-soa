#!/bin/bash

mkdir -p secrets
echo "$(cd shared_services && terraform output -json hcp_us_east_1 | jq -r .boundary.password)" > secrets/boundary_admin

boundary authenticate password \
    -login-name=$(cd shared_services && terraform output -json hcp_us_east_1 | jq -r .boundary.username) \
    -password file://secrets/boundary_admin

boundary connect postgres \
    -dbname=customers \
    -target-name database-admin-customers \
    -target-scope-name=runtime_eks \
    -- -f runtime_eks/scripts/setup.sql