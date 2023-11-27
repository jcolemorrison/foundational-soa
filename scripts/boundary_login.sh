#!/bin/bash

set -x

WORKING_DIR=$(pwd)

boundary_login() {
    export BOUNDARY_ADDR=$(cd shared_services && terraform output -json hcp_us_east_1 | jq -r .boundary.address)

    mkdir -p secrets/

    (cd shared_services && terraform output -json hcp_us_east_1 | jq -r .boundary.password) > secrets/boundary_admin
    cd $WORKING_DIR

    boundary authenticate password -login-name=$(cd shared_services && terraform output -json hcp_us_east_1 | jq -r .boundary.username) -password file://secrets/boundary_admin
}

boundary_login