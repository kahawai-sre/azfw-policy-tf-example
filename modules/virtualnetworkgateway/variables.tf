variable "name" {
}

variable "resource_group_name" {
}

variable "location" {
}

variable "type" {
    default = null
}

variable "vpn_type" {
    default = "RouteBased"
}

variable "sku" {
    default = null
}

variable "enable_bgp" {
    default = false
}

variable "bgp_asn_number" {
    default = ""
}

variable "bgp_peering_addresses" {
    default = null
    type = any
}

variable "bgp_apipa_addresses" {
    default = null  
}
# variable "bgp_peering_address" {
#     default = null
# }

variable "bgp_peer_weight" {
    default = 10
}

variable "active_active" {
    default = false
}

variable "ip_configuration" {
  type = any
  default = null
}

variable "tags" {
  type        = map(string)
  default = null
}

variable "private_ip_address_enabled" {
  default = false
}

variable "vpn_client_configuration" {
  default = null
}
variable "generation" {
  default = "None"
}

variable "default_addresses" {
  default = null
  
}

variable "ip_configuration_name" {
  default = null
  
}

variable "tunnel_ip_addresses" {
  default = null
  
}
