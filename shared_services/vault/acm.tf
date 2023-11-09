resource "aws_acmpca_certificate_authority" "root" {
  type = "ROOT"

  certificate_authority_configuration {
    key_algorithm     = "RSA_4096"
    signing_algorithm = "SHA512WITHRSA"

    subject {
      common_name = var.certificate_common_name
    }
  }
}

resource "aws_acmpca_certificate" "root" {
  certificate_authority_arn   = aws_acmpca_certificate_authority.root.arn
  certificate_signing_request = aws_acmpca_certificate_authority.root.certificate_signing_request
  signing_algorithm           = "SHA512WITHRSA"

  template_arn = "arn:${data.aws_partition.current.partition}:acm-pca:::template/RootCACertificate/V1"

  validity {
    type  = "DAYS"
    value = 180
  }
}

resource "aws_acmpca_certificate_authority_certificate" "root" {
  certificate_authority_arn = aws_acmpca_certificate_authority.root.arn

  certificate       = aws_acmpca_certificate.root.certificate
  certificate_chain = aws_acmpca_certificate.root.certificate_chain
}

resource "aws_acmpca_certificate_authority" "subordinate_level_1" {
  type = "SUBORDINATE"

  certificate_authority_configuration {
    key_algorithm     = "RSA_4096"
    signing_algorithm = "SHA512WITHRSA"

    subject {
      common_name = "consul.${var.certificate_common_name}"
    }
  }
}

resource "aws_acmpca_certificate" "subordinate_level_1" {
  certificate_authority_arn   = aws_acmpca_certificate_authority.root.arn
  certificate_signing_request = vault_pki_secret_backend_intermediate_cert_request.consul_connect_root.csr
  signing_algorithm           = "SHA512WITHRSA"

  template_arn = "arn:${data.aws_partition.current.partition}:acm-pca:::template/SubordinateCACertificate_PathLen1/V1"

  validity {
    type  = "DAYS"
    value = 60
  }
}

resource "aws_acmpca_certificate_authority" "subordinate_level_2" {
  type = "SUBORDINATE"

  certificate_authority_configuration {
    key_algorithm     = "RSA_4096"
    signing_algorithm = "SHA512WITHRSA"

    subject {
      common_name = "consul.${var.certificate_common_name}"
    }
  }
}

resource "aws_acmpca_certificate" "subordinate_level_2" {
  certificate_authority_arn   = aws_acmpca_certificate_authority.subordinate_level_1.arn
  certificate_signing_request = vault_pki_secret_backend_intermediate_cert_request.consul_connect_pki.csr
  signing_algorithm           = "SHA512WITHRSA"

  template_arn = "arn:${data.aws_partition.current.partition}:acm-pca:::template/SubordinateCACertificate_PathLen1/V1"

  validity {
    type  = "DAYS"
    value = 60
  }
}

resource "aws_acmpca_certificate_authority" "subordinate_level_3" {
  type = "SUBORDINATE"

  certificate_authority_configuration {
    key_algorithm     = "RSA_4096"
    signing_algorithm = "SHA512WITHRSA"

    subject {
      common_name = "consul.${var.certificate_common_name}"
    }
  }
}

resource "aws_acmpca_certificate" "subordinate_level_3" {
  certificate_authority_arn   = aws_acmpca_certificate_authority.subordinate_level_2.arn
  certificate_signing_request = vault_pki_secret_backend_intermediate_cert_request.consul_connect_pki_int.csr
  signing_algorithm           = "SHA512WITHRSA"

  template_arn = "arn:${data.aws_partition.current.partition}:acm-pca:::template/SubordinateCACertificate_PathLen1/V1"

  validity {
    type  = "DAYS"
    value = 60
  }
}