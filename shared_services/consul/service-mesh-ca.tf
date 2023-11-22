resource "consul_certificate_authority" "connect_us_east_1" {
  connect_provider = "vault"

  config_json = jsonencode({
    Address                  = local.vault.us_east_1.private_address
    Token                    = sensitive(local.consul_ca.us_east_1.token)
    RootPKIPath              = local.consul_ca.us_east_1.pki_path
    RootPKINamespace         = local.consul_ca.us_east_1.namespace
    IntermediatePKIPath      = local.consul_ca.us_east_1.pki_int_path
    IntermediatePKINamespace = local.consul_ca.us_east_1.namespace
    LeafCertTTL              = "2160h"
    RotationPeriod           = "2160h"
    IntermediateCertTTL      = "8760h"
    PrivateKeyType           = "rsa"
    PrivateKeyBits           = 4096
  })

  provider = consul.us_east_1
}

resource "consul_certificate_authority" "connect_us_west_2" {
  connect_provider = "vault"

  config_json = jsonencode({
    Address                  = local.vault.us_west_2.private_address
    Token                    = sensitive(local.consul_ca.us_west_2.token)
    RootPKIPath              = local.consul_ca.us_west_2.pki_path
    RootPKINamespace         = local.consul_ca.us_west_2.namespace
    IntermediatePKIPath      = local.consul_ca.us_west_2.pki_int_path
    IntermediatePKINamespace = local.consul_ca.us_west_2.namespace
    LeafCertTTL              = "2160h"
    RotationPeriod           = "2160h"
    IntermediateCertTTL      = "8760h"
    PrivateKeyType           = "rsa"
    PrivateKeyBits           = 4096
  })

  provider = consul.us_west_2
}

resource "consul_certificate_authority" "connect_eu_west_1" {
  connect_provider = "vault"

  config_json = jsonencode({
    Address                  = local.vault.eu_west_1.private_address
    Token                    = sensitive(local.consul_ca.eu_west_1.token)
    RootPKIPath              = local.consul_ca.eu_west_1.pki_path
    RootPKINamespace         = local.consul_ca.eu_west_1.namespace
    IntermediatePKIPath      = local.consul_ca.eu_west_1.pki_int_path
    IntermediatePKINamespace = local.consul_ca.eu_west_1.namespace
    LeafCertTTL              = "2160h"
    RotationPeriod           = "2160h"
    IntermediateCertTTL      = "8760h"
    PrivateKeyType           = "rsa"
    PrivateKeyBits           = 4096
  })

  provider = consul.eu_west_1
}