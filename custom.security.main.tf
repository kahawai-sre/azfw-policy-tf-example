
module "resourcegroup-security" {
    for_each = local.security_resourcegroups_config_map
    providers = {
      azurerm = azurerm.security
    }
    source = "./modules/resourcegroup/"
    name = each.value.resource_name
    location  = each.value.location
    tags = each.value.tags
}


module "ipprefixes-security" {
    depends_on = [
      module.resourcegroup-security
    ]
    providers = {
      azurerm = azurerm.security
    }
    for_each = local.security_ipprefixes_config_map == null ? {} : local.security_ipprefixes_config_map
    #var.ddos_protection_plan_name == null ? range(0) : range(1)
    source = "./modules/ipprefix"
    name                         = each.value.name
    resource_group_name          = each.value.resource_group_name
    location                     = each.value.location
    prefix_length                = each.value.prefix_length
    sku                          = each.value.sku
    zones                        = each.value.zones # Zone Redundant for standard SKU by default
    tags                         = each.value.tags #map
}

module "publicips-security" {
    depends_on = [
      module.ipprefixes-security
    ]
    providers = {
      azurerm = azurerm.security
    }
    for_each = local.security_publicips_config_map == null ? {} : local.security_publicips_config_map
    source = "./modules/publicip"
    name                         = each.value.name
    resource_group_name          = each.value.resource_group_name
    location                     = each.value.location
    allocation_method            = each.value.allocation_method
    sku                          = each.value.sku
    ip_version                   = each.value.ip_version
    idle_timeout_in_minutes      = each.value.idle_timeout_in_minutes
    domain_name_label            = each.value.domain_name_label
    reverse_fqdn                 = each.value.reverse_fqdn
    public_ip_prefix_id          = try(module.ipprefixes-security[each.value.public_ip_prefix_name].id, null)
    zones                        = each.value.zones # Zone Redundant for standard SKU by default
    tags                         = each.value.tags #map
}

module "ipgroups-security" {
    depends_on = [
        module.resourcegroup-security
    ]
    providers = {
      azurerm = azurerm.security
    }
    for_each = local.security_ipgroups_config_map == null ? {} : local.security_ipgroups_config_map
    #var.ddos_protection_plan_name == null ? range(0) : range(1)
    source = "./modules/ipgroup"
    name                         = each.value.name
    resource_group_name          = each.value.resource_group_name
    location                     = each.value.location
    cidrs                        = each.value.cidrs
    tags                         = each.value.tags #map
}

module "azurefirewallbasepolicy-security" {
    depends_on = [
      module.resourcegroup-security,module.publicips-security,module.ipgroups-security
    ]
    providers = {
      azurerm = azurerm.security
    }
    for_each = local.security_azurefirewallpols_config_map_ae  == null ? {} : local.security_azurefirewallpols_config_map_ae
    source = "./modules/azurefirewallpolicy"
    name = each.value.name
    resource_group_name = each.value.resource_group_name
    location = each.value.location
    sku = each.value.sku
    threat_intelligence_mode = each.value.threat_intelligence_mode
    threat_intelligence_allowlist = each.value.threat_intelligence_allowlist
    dns = each.value.dns
    tags = each.value.tags
}

module "azurefirewallchildpolicy-security" {
    depends_on = [
      module.azurefirewallbasepolicy-security, module.resourcegroup-security
    ]
    providers = {
      azurerm = azurerm.security
    }
    for_each = local.security_azurefirewallchildpols_config_map_ae  == null ? {} : local.security_azurefirewallchildpols_config_map_ae
    source = "./modules/azurefirewallpolicy"
    name = each.value.name
    resource_group_name = each.value.resource_group_name
    location = each.value.location
    sku = each.value.sku
    base_policy_id = module.azurefirewallbasepolicy-security[each.value.base_policy_name].firewallpolicy_id
    threat_intelligence_mode = each.value.threat_intelligence_mode
    threat_intelligence_allowlist = each.value.threat_intelligence_allowlist
    dns = each.value.dns
    identity = each.value.identity
    tls_certificate = each.value.tls_certificate
    explicit_proxy = each.value.explicit_proxy
    intrusion_detection = each.value.intrusion_detection
    insights = each.value.insights
    tags = each.value.tags
}

module "azurefirewallpolicyrulecollectiongroup-security" {
    providers = {
      azurerm = azurerm.security
    }     
    depends_on = [
       module.resourcegroup-security, module.azurefirewallbasepolicy-security, module.azurefirewallchildpolicy-security
    ]
    for_each = local.security_azurefirewallpolrulecollectiongroups_config_map_ae == null ? {} : local.security_azurefirewallpolrulecollectiongroups_config_map_ae
    source = "./modules/azurefirewallpolicyrulecollectiongroup"
    name                            = each.value.name
    priority                        = each.value.priority
    firewall_policy_id              = module.azurefirewallchildpolicy-security[each.value.fw_policy_name].firewallpolicy_id
    application_rule_collection = each.value.application_rule_collections == null ? null : [for application_rule_collection in each.value.application_rule_collections :
    {
        name = application_rule_collection.name,
        action = application_rule_collection.action,
        priority = application_rule_collection.priority,
        rules = [ for rule in application_rule_collection.rules :
            {
                name = rule.name,
                source_addresses = rule.source_addresses,
                source_ip_groups = lookup(rule,"source_ip_groups", null) == null ? null : [for ipgroupname in rule.source_ip_groups: module.ipgroups-security[ipgroupname].ipgroup_id],
                destination_fqdns = rule.destination_fqdns,
                destination_fqdn_tags = try(rule.destination_fqdn_tags, null),
                protocols = rule.protocols
            }
        ]
    }]
    network_rule_collection = each.value.network_rule_collections == null ? null : [for network_rule_collection in each.value.network_rule_collections :
    {
        name = network_rule_collection.name,
        action = network_rule_collection.action,
        priority = network_rule_collection.priority,
        rules = [ for rule in network_rule_collection.rules :
            {
                name = rule.name,
                source_addresses = rule.source_addresses,
                source_ip_groups = lookup(rule,"source_ip_groups", null) == null ? null : [for ipgroupname in rule.source_ip_groups: module.ipgroups-security[ipgroupname].ipgroup_id],
                destination_addresses = rule.destination_addresses,
                destination_ip_groups = lookup(rule,"destination_ip_groups", null) == null ? null : [for ipgroupname in rule.destination_ip_groups: module.ipgroups-security[ipgroupname].ipgroup_id],
                destination_fqdns = try(rule.destination_fqdns,null),
                destination_ports = rule.destination_ports,
                protocols = rule.protocols
            }
        ]
    }]
    nat_rule_collection = each.value.nat_rule_collections == null ? null : [for nat_rule_collection in each.value.nat_rule_collections :
    {
        name = nat_rule_collection.name,
        action = nat_rule_collection.action,
        priority = nat_rule_collection.priority,
        rules = [ for rule in nat_rule_collection.rules :
            {
                name = rule.name,
                source_ip_groups = lookup(rule,"source_ip_groups", null) == null ? null : [for ipgroupname in rule.source_ip_groups: module.ipgroups-security[ipgroupname].ipgroup_id],
                destination_address = lookup(rule,"destination_address_public_ip_name", null) == null ? null : module.publicips-security[rule.destination_address_public_ip_name].publicip_ip,
                destination_ports = rule.destination_ports,
                source_addresses = rule.source_addresses,
                protocols = rule.protocols,
                translated_address = rule.translated_address,
                translated_port = rule.translated_port
            }
        ]
    }]
}