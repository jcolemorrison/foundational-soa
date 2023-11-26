resource "aws_instance" "instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = false
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  key_name                    = var.key_pair_name

  user_data = templatefile("${path.module}/templates/user_data.sh", {
    setup = base64gzip(templatefile("${path.module}/templates/setup.sh", {
      consul_ca        = data.hcp_consul_cluster.cluster.consul_ca_file
      consul_config    = data.hcp_consul_cluster.cluster.consul_config_file
      consul_acl_token = var.hcp_consul_cluster_token
      consul_version   = data.hcp_consul_cluster.cluster.consul_version
      envoy = base64encode(templatefile("${path.module}/templates/services/envoy", {
        service_name     = var.name,
        consul_acl_token = var.hcp_consul_cluster_token
      })),
      vpc_cidr = var.vpc_cidr_block
    })),
  })

  tags = local.tags
}
