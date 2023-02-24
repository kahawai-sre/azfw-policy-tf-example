
variable "name" {
}

variable "resource_group_name" {
}

variable "location" {
}

variable "disable_bgp_route_propagation" {
  default = false
}

variable "routes" {
    type = any
    default = null
}

variable "tags" {
  type = map(string)
  default = null
}
