#!/bin/bash

mkdir -p secrets
@echo "$(cd shared_services && terraform output -json hcp_us_east_1 | jq -r .boundary.password)" > secrets/boundary_admin
boundary authenticate password -login-name=$(cd shared_services && terraform output -json hcp_us_east_1 | jq -r .boundary.username) \
    -password file://secrets/admin

