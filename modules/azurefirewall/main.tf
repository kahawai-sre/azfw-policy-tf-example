

resource "azurerm_firewall" "this" {
  name     = var.name
  location = var.location
  resource_group_name = var.resource_group_name
  sku_name = var.sku_name # AZFW_VNet or AZFW_Hub
  sku_tier = var.sku_tier # Standard or Premium. Premium not currently available in virtual hub (AZFW_Hub)
  firewall_policy_id = var.firewall_policy_id
  threat_intel_mode = var.threat_intel_mode # Off, Alert, Deny, or ''. '' must be used if virtual_hub_setting is specified
  zones = var.zones
  dns_servers = var.dns_servers
  # // One or more IP blocks. At leats one is required and one and only one should specify subnet_id (for AzureFirewallSubnet). 
  # // Additional may be specified for scaling concurrent sessions, DNAT pool..
  dynamic "ip_configuration" {
    for_each = var.ip_configurations == null ? [] : var.ip_configurations
    content {
      name = ip_configuration.value.name
      subnet_id = lookup(ip_configuration.value, "subnet_id", null) == null ? null : ip_configuration.value.subnet_id # At least /26. Only ONE ip configuration should include subnet (AzureFirewallSubnet)
      public_ip_address_id = ip_configuration.value.public_ip_address_id # Standard SKU, Static allocation only
    }
  }  
  # // Optional Management IP confguration for Force Tunnel mode
  dynamic "management_ip_configuration" {
    for_each = var.management_ip_configuration == null ? [] : var.management_ip_configuration
    content {
      name = management_ip_configuration.value.name
      public_ip_address_id = management_ip_configuration.value.public_ip_address_id
      subnet_id = management_ip_configuration.value.subnet_id
    }
  }
  # // Optional Virtual Hub config for AZFW_Hub (vWAN) integration
  dynamic "virtual_hub" {
    for_each = var.virtual_hub == null ? [] : var.virtual_hub
    content {
      virtual_hub_id = virtual_hub.value.virtual_hub_name
      public_ip_count = virtual_hub.value.public_ip_count
    }
  }
  tags = var.tags // map
}


