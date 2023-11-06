data "terraform_remote_state" "shared_services" {
  backend = "remote"

  config = {
    organization = var.terraform_cloud_organization
    workspaces = {
      name = "shared-services"
    }
  }
}