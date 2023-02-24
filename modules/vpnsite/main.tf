
resource "azurerm_vpn_site" "this" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  virtual_wan_id                = var.virtual_wan_id
  address_cidrs                 = var.address_cidrs == null ? [] : var.address_cidrs
  dynamic "link" {
    for_each = var.link == null ? [] : var.link
    content {
      name = link.value.name
      ip_address = link.value.ip_address
      provider_name = link.value.provider_name
      speed_in_mbps = link.value.speed_in_mbps
      bgp {
        asn       = link.value.bgp_asn
        peering_address = link.value.bgp_peering_address
      }
    }
  }

}