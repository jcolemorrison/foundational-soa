variable "org_scope_id" {
    type = string
    description = "Organization scope ID in Boundary for project scope related to runtime."
}

variable "scope_name" {
    type = string
    description = "Name for Boundary project scope related to runtime."
}

variable "scope_description" {
    type = string
    description = "Description for Boundary project scope related to runtime."
}

variable "name_prefix" {
    type = string
    description = "Name prefix for Boundary host catalog."
}

variable "target_ips" {
    type = map(string)
    description = "Map of IP address and hostname of target IPs for host catalog."
}

variable "description" {
    type = string
    description = "Description for host catalog and host sets."
    default = null
}