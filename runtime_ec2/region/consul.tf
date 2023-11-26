resource "consul_config_entry" "exported_services_payments_ec2" {
  name      = "ec2"
  kind      = "exported-services"
  partition = "ec2"

  config_json = jsonencode({
    Services = [{
      Name      = "payments"
      Namespace = "default"
      Consumers = [
        {
          Partition = "default"
        },
        {
          SamenessGroup = var.sameness_group
        }
      ]
    }]
  })
}
