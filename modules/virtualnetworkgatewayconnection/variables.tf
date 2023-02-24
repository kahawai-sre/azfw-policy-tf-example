variable "name" {
}

variable "resource_group_name" {
}

variable "location" {
}

variable "type" {
    default = null
}

variable "virtual_network_gateway_id" {
  default = null
}

variable "authorization_key" {
  default = null
}

variable "local_network_gateway_id" {
  default = null
}

variable "local_azure_ip_address_enabled" {
  default = false
}

variable "express_route_circuit_id" {
  default = null
}

variable "shared_key" {
  default = null
}

variable "tags" {
  type        = map(string)
  default = null
}

variable "enable_bgp" {
  default = false
}

variable "ipsec_policy" {
  type = any
  default = null
}

variable "routing_weight" {
  default = 10
  
}