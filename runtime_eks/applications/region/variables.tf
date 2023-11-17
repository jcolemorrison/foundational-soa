variable "region" {
  type        = string
  description = "Region of service"
}

variable "namespace" {
    type = string
    description = "Namespace for services"
}

locals {
  service_ports = {
    web         = 9090
    application = 9090
    database    = 9090
  }
}
