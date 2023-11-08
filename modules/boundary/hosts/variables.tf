variable "scope_id" {
    type = string
    description = "Scope ID for Boundary host catalog"
}

variable "name_prefix" {
    type = string
    description = "Name prefix for Boundary host catalog."
}

variable "target_ips" {
    type = map(string)
    description = "Map of instance ID and IP address of hosts to register"
}

variable "description" {
    type = string
    description = "Description for host catalog and host sets."
}