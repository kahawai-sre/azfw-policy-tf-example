resource "azurerm_local_network_gateway" "this" {

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  gateway_address     = var.gateway_address
  address_space       = var.address_space

  bgp_settings {
    asn = var.asn
    bgp_peering_address = var.bgp_peering_address
    peer_weight         = var.peer_weight
  }
}
