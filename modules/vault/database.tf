
resource "vault_kv_secret_v2" "database" {
  count               = var.db_name != null ? 1 : 0
  mount               = vault_mount.static.path
  name                = "${var.db_name}-admin"
  delete_all_versions = true

  data_json = <<EOT
{
  "username": "${var.db_username}",
  "password": "${var.db_password}"
}
EOT
}

resource "vault_mount" "database" {
  count = var.db_name != null ? 1 : 0
  path  = "database/${var.db_name}"
  type  = "database"
}

resource "vault_database_secret_backend_connection" "database" {
  count         = var.db_name != null ? 1 : 0
  backend       = vault_mount.database.0.path
  name          = var.db_name
  allowed_roles = [var.db_name]

  postgresql {
    connection_url = "postgresql://{{username}}:{{password}}@${var.db_address}:${var.db_port}/${var.db_name}?sslmode=disable"
    username       = var.db_username
    password       = var.db_password
  }
}

resource "vault_database_secret_backend_role" "database" {
  count                 = var.db_name != null ? 1 : 0
  backend               = vault_mount.database.0.path
  name                  = var.db_name
  db_name               = vault_database_secret_backend_connection.database.0.name
  creation_statements   = ["CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT ALL PRIVILEGES ON ${var.db_name} TO \"{{name}}\";"]
  revocation_statements = ["ALTER ROLE \"{{name}}\" NOLOGIN;"]
  default_ttl           = 3600
  max_ttl               = 3600
}

data "vault_policy_document" "database" {
  count = var.db_name != null ? 1 : 0
  rule {
    path         = "${vault_mount.database.0.path}/creds/${vault_database_secret_backend_role.database.0.name}"
    capabilities = ["read"]
    description  = "get database credentials for ${vault_database_secret_backend_role.database.0.name}"
  }
}

resource "vault_policy" "database" {
  count  = var.db_name != null ? 1 : 0
  name   = "${var.service}-database-${vault_database_secret_backend_role.database.0.name}-read"
  policy = data.vault_policy_document.database.0.hcl
}
