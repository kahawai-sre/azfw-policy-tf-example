resource "azurerm_virtual_network_gateway" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  type     = var.type
  vpn_type = var.vpn_type
  generation = var.generation

  active_active = var.active_active
  enable_bgp    = var.enable_bgp
  sku           = var.sku
  private_ip_address_enabled = var.private_ip_address_enabled 

  dynamic "bgp_settings" {
    for_each = var.enable_bgp ? [1] : []
    content {
      asn             = var.bgp_asn_number
      peering_address = var.bgp_peering_addresses
      peer_weight     = var.bgp_peer_weight

    
    dynamic "peering_addresses" {
      for_each = (var.bgp_apipa_addresses != null) && var.enable_bgp ? var.bgp_apipa_addresses : []
      content {
         apipa_addresses       = var.bgp_apipa_addresses

      }
    }
    
    }
  }

  ## active-standy will have one and only one ip_config block, but active-active will get two blocks.
  dynamic "ip_configuration" {
    for_each = var.ip_configuration == null ? [] : var.ip_configuration
    content {
        name                          = ip_configuration.value.name
        public_ip_address_id          = ip_configuration.value.public_ip_address_id
        private_ip_address_allocation = "Dynamic"
        subnet_id                     = ip_configuration.value.subnet_id
    }
  }

  dynamic "vpn_client_configuration" {
    for_each = var.vpn_client_configuration != null ? [var.vpn_client_configuration] : []
    iterator = vpn
    content {
      address_space = [vpn.value.address_space]
      root_certificate {
        name             = "point-to-site-root-certifciate"
        public_cert_data = vpn.value.certificate
      }
      vpn_client_protocols = vpn.value.vpn_client_protocols
    }
  }


  # lifecycle {
  #  ignore_changes = [bgp_settings[0].peering_addresses]
  # }
}

# resource "azurerm_virtual_network_gateway_connection" "this" {
#   name                = var.connection_name
#   location            = var.location
#   resource_group_name = var.resource_group_name

#   type                       = var.connection_type
#   virtual_network_gateway_id = azurerm_virtual_network_gateway.this.id
#   local_network_gateway_id   = var.type == "Vpn" ? azurerm_local_network_gateway.this[0].id : null
#   express_route_circuit_id   = var.type == "ExpressRoute" ? var.express_route_circuit_id  : null
#   authorization_key          = var.type == "ExpressRoute" ? var.authorization_key : null

#   shared_key = var.type == "Vpn" ? var.shared_key : null
#   local_azure_ip_address_enabled = var.local_azure_ip_address_enabled 
#   routing_weight                 = var.routing_weight
#   enable_bgp                     = var.connection_enable_bgp 


#   tags                           = var.tags
#   lifecycle {
#     ignore_changes = [shared_key]
#   }
# }
