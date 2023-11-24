#!/bin/bash
yum update -y
yum install -y unzip

# ECS Configuration

echo ECS_CLUSTER='${ECS_CLUSTER_NAME}' >> /etc/ecs/ecs.config

# --- #

# Vault Configuration

# Make the user
useradd --system --shell /sbin/nologin vault

# Make the directories
mkdir -p /opt/vault
mkdir -p /opt/vault/bin
mkdir -p /opt/vault/config
mkdir -p /opt/vault/tls
mkdir -p /opt/vault/token

# Give corret permissions
chmod 755 /opt/vault
chmod 755 /opt/vault/bin

# Change ownership to vault user
chown -R vault:vault /opt/vault

# Get the HashiCorp PGP
curl https://keybase.io/hashicorp/pgp_keys.asc | gpg --import

# Download vault and signatures
curl -Os https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip
curl -Os https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS
curl -Os https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS.sig

# Verify Signatres
gpg --verify vault_${VAULT_VERSION}_SHA256SUMS.sig vault_${VAULT_VERSION}_SHA256SUMS
cat vault_${VAULT_VERSION}_SHA256SUMS | grep vault_${VAULT_VERSION}_linux_amd64.zip | sha256sum -c

# unzip and move to /opt/vault/bin
unzip vault_${VAULT_VERSION}_linux_amd64.zip
mv vault /opt/vault/bin

# give ownership to the vault user
chown vault:vault /opt/vault/bin/vault

# create a symlink
ln -s /opt/vault/bin/vault /usr/local/bin/vault

# allow vault permissions to use mlock and prevent memory from swapping to disk
setcap cap_ipc_lock=+ep /opt/vault/bin/vault

# cleanup files
rm vault_${VAULT_VERSION}_linux_amd64.zip
rm vault_${VAULT_VERSION}_SHA256SUMS
rm vault_${VAULT_VERSION}_SHA256SUMS.sig

# The vault agent config file
cat > /opt/vault/config/agent.hcl <<- EOF
pid_file = "/opt/vault/pidfile"

auto_auth {
  method "aws" {
      mount_path = "auth/aws"
      namespace = "${VAULT_NAMESPACE}"
      config = {
          type = "iam"
          role = "${VAULT_ROLE}"
      }
  }

  sink "file" {
      config = {
          path = "/opt/vault/vault-token-via-agent"
      }
  }
}

template_config {
   static_secret_render_interval = "5m"
   exit_on_retry_failure         = true
}

vault {
   address = "${VAULT_ADDR}"
}

env_template "API_KEY" {
   contents             = "{{ with secret \"kv/data/prod-ecs-api-key\" }}{{ .Data.data.apikey }}{{ end }}"
   error_on_missing_key = true
}
EOF

chown vault:vault /opt/vault/config/agent.hcl

# The systemd service file
cat > /etc/systemd/system/vault.service <<- EOF
[Unit]
Description=VaultAgentECS
Requires=network-online.target
After=network-online.target

[Service]
User=vault
Group=vault
ProtectSystem=full
ProtectHome=read-only
PrivateTmp=yes
PrivateDevices=yes
SecureBits=keep-caps
AmbientCapabilities=CAP_IPC_LOCK
Capabilities=CAP_IPC_LOCK+ep
CapabilityBoundingSet=CAP_SYSLOG CAP_IPC_LOCK
NoNewPrivileges=yes
ExecStart=/opt/vault/bin/vault agent -config=/opt/vault/config/ -log-level=info
ExecReload=/bin/kill --signal HUP \$MAINPID
KillMode=process
KillSignal=SIGINT
Restart=on-failure
RestartSec=5
TimeoutStopSec=30
StartLimitInterval=60
StartLimitBurst=3
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable vault
systemctl restart vault