resource "aws_instance" "instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = false
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  key_name                    = var.key_pair_name

  user_data = templatefile("${path.module}/templates/user_data.sh", {
    setup = base64gzip(templatefile("${path.module}/templates/setup.sh", {
      service_name     = var.name,
      consul_ca        = data.hcp_consul_cluster.cluster.consul_ca_file
      consul_config    = data.hcp_consul_cluster.cluster.consul_config_file
      consul_acl_token = var.hcp_consul_cluster_token
      consul_version   = data.hcp_consul_cluster.cluster.consul_version
      service = base64encode(templatefile("${path.module}/templates/services/fake-service", {
        service_name  = var.fake_service_name,
        service_port  = var.fake_service_port,
        message       = var.fake_service_message,
        upstream_uris = var.upstream_service_name != null ? "http://127.0.0.1:${var.upstream_service_local_bind_port}" : null
      })),
      service_definition = base64encode(templatefile("${path.module}/templates/service_definition", {
        service_name                     = var.name,
        service_port                     = var.fake_service_port
        consul_acl_token                 = var.hcp_consul_cluster_token
        upstream_service_name            = var.upstream_service_name
        upstream_service_local_bind_port = var.upstream_service_local_bind_port
      })),
      envoy = base64encode(templatefile("${path.module}/templates/services/envoy", {
        service_name     = var.name,
        consul_acl_token = var.hcp_consul_cluster_token
      })),
      vpc_cidr = var.vpc_cidr_block
    })),
  })

  tags = local.tags
}
