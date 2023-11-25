#!/usr/bin/env bash
# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

set -ex

setup_service() {
  curl -LO https://github.com/nicholasjackson/fake-service/releases/download/v0.26.0/fake_service_linux_amd64.zip
  unzip fake_service_linux_amd64.zip
  mv fake-service /usr/local/bin
  chmod +x /usr/local/bin/fake-service
}

start_service() {
  mv $1.service /usr/lib/systemd/system/
  systemctl enable $1.service
  systemctl start $1.service
}

setup_deps() {
  add-apt-repository universe -y
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
  apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

  curl -LO https://github.com/envoyproxy/envoy/releases/download/v1.27.2/envoy-1.27.2-linux-x86_64
  mv envoy-1.27.2-linux-x86_64 /usr/local/bin/envoy
  chmod +x /usr/local/bin/envoy

  version="${consul_version}"
  consul_package="consul-enterprise="$${version:1}"*"
  apt install -qy apt-transport-https gnupg2 curl lsb-release $${consul_package} unzip jq apache2-utils nginx
}

setup_consul() {
  mkdir --parents /etc/consul.d /var/consul
  chown --recursive consul:consul /etc/consul.d
  chown --recursive consul:consul /var/consul

  echo "${consul_ca}" | base64 -d >/etc/consul.d/ca.pem
  echo "${consul_config}" | base64 -d >client.temp.0
  ip=$(hostname -I | awk '{print $1}')
  jq '.tls.defaults.ca_file = "/etc/consul.d/ca.pem"' client.temp.0 >client.temp.1
  jq --arg token "${consul_acl_token}" '.acl += {"tokens":{"agent":"\($token)"}}' client.temp.1 >client.temp.2
  jq '.ports = {"grpc":8502}' client.temp.2 > client.temp.3
  jq '.partition = "ec2"' client.temp.3 > client.temp.4
  jq '.data_dir = "/opt/consul"' client.temp.4 > client.temp.5
  jq '.connect.enabled = true' client.temp.5 > client.temp.6
  jq '.bind_addr = "{{ GetPrivateInterfaces | include \"network\" \"'${vpc_cidr}'\" | attr \"address\" }}"' client.temp.6 >/etc/consul.d/client.json
}

start_consul() {
  systemctl enable consul.service
  systemctl start consul.service
}

cd /home/ubuntu/

setup_deps
setup_consul

%{if service_name != null}
setup_service
echo "${service}" | base64 -d > ${service_name}.service
start_service "${service_name}"

echo "${service_definition}" | base64 -d > /etc/consul.d/${service_name}.hcl
%{endif}

echo "${envoy}" | base64 -d > consul-envoy.service

start_consul

sleep 30

start_service "consul-envoy"

# nomad and consul service is type simple and might not be up and running just yet.
sleep 10

echo "done"