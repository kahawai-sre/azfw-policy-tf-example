resource "azurerm_vpn_gateway" "this" {
  name                              = var.name
  location                          = var.location
  resource_group_name               = var.resource_group_name
  virtual_hub_id                    = var.virtual_hub_id
  scale_unit                        = var.scale_unit
  # bgp_settings {
  #   asn                             = var.asn
  #   peer_weight                     = var.peer_weight
  #   instance_0_bgp_peering_address {
  #     custom_ips                    = var.custom_ips
  #   }
  # }
}