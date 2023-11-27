#!/bin/bash

set -e

WORKING_DIR=$(pwd)

get_hcp_credentials() {
    cd $WORKING_DIR

    mkdir -p secrets

    cd shared_services

    terraform output -json hcp_us_east_1 | jq . > ../secrets/hcp_us_east_1.json
    terraform output -json hcp_us_west_2 | jq . > ../secrets/hcp_us_west_2.json
    terraform output -json hcp_eu_west_1 | jq . > ../secrets/hcp_eu_west_1.json
}

get_ssh_keys() {
    RUNTIME=$1

    cd $RUNTIME
    rm -rf secrets/*.pem
    mkdir -p secrets

    terraform output -json ssh_keys | jq -r ".us_east_1" | base64 -d > secrets/us_east_1.pem 
    terraform output -json ssh_keys | jq -r ".us_west_2" | base64 -d > secrets/us_west_2.pem 
    terraform output -json ssh_keys | jq -r ".eu_west_1" | base64 -d > secrets/eu_west_1.pem

    chmod 400 secrets/us_east_1.pem
    chmod 400 secrets/us_west_2.pem
    chmod 400 secrets/eu_west_1.pem
}

(get_ssh_keys "runtime_ec2")
(get_ssh_keys "runtime_ecs")
(get_ssh_keys "runtime_eks")

(get_hcp_credentials)