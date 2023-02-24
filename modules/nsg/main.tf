
#https://github.com/JamesDLD/terraform-azurerm-Az-VirtualNetwork/blob/master/main.tf
resource "azurerm_network_security_group" "this" {
  name                     = var.name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  dynamic "security_rule" {
    for_each = var.security_rules == null ? [] : var.security_rules
    content {
      name = security_rule.value.name
      description = security_rule.value.description
      direction = security_rule.value.direction
      access = security_rule.value.access
      priority = security_rule.value.priority
      source_address_prefix = try(security_rule.value.source_address_prefix, null)
      destination_address_prefix = try(security_rule.value.destination_address_prefix, null)
      source_address_prefixes = try([for item in split(",",security_rule.value.source_address_prefixes): item], null)
      destination_address_prefixes =  try([for item in split(",",security_rule.value.destination_address_prefixes): item], null)
      source_application_security_group_ids = try([for item in split(",",security_rule.value.source_application_security_group_ids): item], null)
      destination_application_security_group_ids = try([for item in split(",",security_rule.value.destination_application_security_group_ids): item], null)
      source_port_range = try(security_rule.value.source_port_range,  null)
      destination_port_range = try(security_rule.value.destination_port_range, null)
      source_port_ranges = try([for item in split(",",security_rule.value.source_port_ranges): item], null)
      destination_port_ranges = try([for item in split(",",security_rule.value.destination_port_ranges): item],null)
      protocol = try(security_rule.value.protocol, null)
      /*
      source_address_prefix = security_rule.value.source_address_prefix == null ? null : security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix == null ? null : security_rule.value.destination_address_prefix
      source_address_prefixes = security_rule.value.source_address_prefixes == null ? null :  [for item in split(",",security_rule.value.source_address_prefixes): item]
      destination_address_prefixes = security_rule.value.destination_address_prefixes == null ? null : [for item in split(",",security_rule.value.destination_address_prefixes): item]
      source_application_security_group_ids = security_rule.value.source_application_security_group_ids == null ? null :  [for item in split(",",security_rule.value.source_application_security_group_ids): item]
      destination_application_security_group_ids = security_rule.value.destination_application_security_group_ids  == null ? null :  [for item in split(",",security_rule.value.destination_application_security_group_ids): item]
      source_port_range = security_rule.value.source_port_range == null ? null : security_rule.value.source_port_range
      destination_port_range = security_rule.value.destination_port_range == null ? null : security_rule.value.destination_port_range
      source_port_ranges = security_rule.value.source_port_ranges == null ? null : [for item in split(",",security_rule.value.source_port_ranges): item]
      destination_port_ranges = security_rule.value.destination_port_ranges == null ? null : [for item in split(",",security_rule.value.destination_port_ranges): item]
      protocol = security_rule.value.protocol == null ? null : security_rule.value.protocol
      */
    }
  }
  tags = var.tags
}


