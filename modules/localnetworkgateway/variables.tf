
variable "name" {
}

variable "resource_group_name" {
}

variable "location" {
} 

variable "gateway_address" {
  description = "the endpoint type for the on-premises VPN device - IP address "
}

variable "address_space" {
  description = "refers to the address ranges for the network that this local network represents"
  type = list
}

variable "asn" {
  default = null
}

variable "bgp_peering_address" {
  default = null
}

variable "peer_weight" {
  default = 10
}

variable "tags" {
  type        = map(string)
  default = null
}

