## Set up Consul cluster peering between us-east-1 and us-west-2
resource "consul_peering_token" "us_east_1_to_us_west_2" {
  provider  = consul.us_east_1
  peer_name = data.terraform_remote_state.shared_services.outputs.hcp_us_west_2.consul.id
}

resource "consul_peering" "us_east_1_to_us_west_2" {
  provider = consul.us_west_2

  peer_name     = data.terraform_remote_state.shared_services.outputs.hcp_us_east_1.consul.id
  peering_token = consul_peering_token.us_east_1_to_us_west_2.peering_token
}

## Set up Consul cluster peering between us-east-1 and eu-west-1
resource "consul_peering_token" "us_east_1_to_eu_west_1" {
  provider  = consul.us_east_1
  peer_name = data.terraform_remote_state.shared_services.outputs.hcp_eu_west_1.consul.id
}

resource "consul_peering" "us_east_1_to_eu_west_1" {
  provider = consul.eu_west_1

  peer_name     = data.terraform_remote_state.shared_services.outputs.hcp_us_east_1.consul.id
  peering_token = consul_peering_token.us_east_1_to_eu_west_1.peering_token
}

## Set up Consul cluster peering between eu-west-1 and us-west-2
resource "consul_peering_token" "eu_west_1_to_us_west_2" {
  provider  = consul.eu_west_1
  peer_name = data.terraform_remote_state.shared_services.outputs.hcp_us_west_2.consul.id
}

resource "consul_peering" "eu_west_1_to_us_west_2" {
  provider = consul.us_west_2

  peer_name     = data.terraform_remote_state.shared_services.outputs.hcp_eu_west_1.consul.id
  peering_token = consul_peering_token.eu_west_1_to_us_west_2.peering_token
}