module "partition_us_east_1" {
  for_each = var.runtimes
  source   = "./region"

  runtime = each.value

  providers = {
    consul = consul.us_east_1
  }
}

module "partition_us_west_2" {
  for_each = var.runtimes
  source   = "./region"

  runtime = each.value

  providers = {
    consul = consul.us_west_2
  }
}

module "partition_eu_west_1" {
  for_each = var.runtimes
  source   = "./region"

  runtime = each.value

  providers = {
    consul = consul.eu_west_1
  }
}