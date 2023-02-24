resource "azurerm_virtual_network_gateway_connection" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  type                       = var.type
  virtual_network_gateway_id = var.virtual_network_gateway_id
  local_network_gateway_id   = var.type == "Ipsec" ? var.local_network_gateway_id : null
  express_route_circuit_id   = var.type == "ExpressRoute" ? var.express_route_circuit_id  : null
  authorization_key          = var.type == "ExpressRoute" ? var.authorization_key : null

  shared_key = var.type == "Ipsec" ? var.shared_key : null  ### express route doesn't support shared key
  
  local_azure_ip_address_enabled = var.local_azure_ip_address_enabled 
  routing_weight                 = var.routing_weight
  enable_bgp                     = var.enable_bgp

  dynamic "ipsec_policy" {
    for_each = var.ipsec_policy != null ? var.ipsec_policy  : []
    content {
        dh_group = ipsec_policy.value.dh_group
        ike_encryption = ipsec_policy.value.ike_encryption
        ike_integrity = ipsec_policy.value.ike_integrity
        ipsec_encryption = ipsec_policy.value.ipsec_encryption
        ipsec_integrity  = ipsec_policy.value.ipsec_integrity
        pfs_group        = ipsec_policy.value.pfs_group
    }
  }

  tags                           = var.tags
  lifecycle {
    ignore_changes = [shared_key]
  }
}



