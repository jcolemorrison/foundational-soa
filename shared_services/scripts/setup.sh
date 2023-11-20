#!/bin/bash

terraform apply -replace='module.hcp_eu_west_1.hcp_vault_cluster_admin_token.vault[0]'
terraform apply -replace='module.hcp_us_east_1.hcp_vault_cluster_admin_token.vault[0]'
terraform apply -replace='module.hcp_us_west_2.hcp_vault_cluster_admin_token.vault[0]'