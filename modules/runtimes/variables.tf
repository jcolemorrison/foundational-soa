variable "access_map" {
  type        = map(list(string))
  description = "Map of service team access to runtimes"
  default = {
    "frontend" = [
      "frontend"
    ]
    "eks" = [
      "store", "customers", "database"
    ]
    "ecs" = []
    "ec2" = [
      "payments", "reports"
    ]
  }
}

variable "runtimes" {
  type        = set(string)
  description = "Set of runtimes for Consul cluster peering"
  default     = ["default", "eks", "ecs", "ec2", "frontend"]
}
