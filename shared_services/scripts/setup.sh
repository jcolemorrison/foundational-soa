#!/bin/bash

terraform taint 'module.hcp_eu_west_1.hcp_vault_cluster_admin_token.vault[0]'
terraform taint 'module.hcp_us_east_1.hcp_vault_cluster_admin_token.vault[0]'
terraform taint 'module.hcp_us_west_2.hcp_vault_cluster_admin_token.vault[0]'