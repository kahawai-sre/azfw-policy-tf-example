locals {
    // Resource Groups ...
    security_resourcegroups_config_raw = yamldecode(file(var.security_resourcegroups_yaml_file_path))
    security_resourcegroups_config_flatten = flatten([
        for resourcegroup in local.security_resourcegroups_config_raw : {
            name = resourcegroup.name
            resource_name = resourcegroup.resource_name
            location = resourcegroup.location
            tags = try(resourcegroup.tags, null)
        }
    ])
    security_resourcegroups_config_map = {for resourcegroup_config in local.security_resourcegroups_config_flatten : resourcegroup_config.name => resourcegroup_config}

    // IP Groups
    security_ipgroups_config_raw = try(yamldecode(file(var.security_ipgroups_yaml_file_path)), null)
    security_ipgroups_config_flatten = try(flatten([
        for ipgroup in local.security_ipgroups_config_raw : {
            name = ipgroup.name
            resource_name = ipgroup.resource_name
            location = ipgroup.location
            resource_group_name = ipgroup.resource_group_name
            cidrs = try(ipgroup.cidrs, null)
            tags = try(ipgroup.tags, null)
        }
    ]), null)
    security_ipgroups_config_map = try({for ipgroup_config in local.security_ipgroups_config_flatten : ipgroup_config.name => ipgroup_config}, null)

    // Public IP prefixes
    security_ipprefixes_config_raw = try(yamldecode(file(var.security_ipprefixes_yaml_file_path)), null)
    security_ipprefixes_config_flatten = try(flatten([
        for ipprefix in local.security_ipprefixes_config_raw : {
            name = ipprefix.name
            resource_name = ipprefix.resource_name
            location = ipprefix.location
            resource_group_name = ipprefix.resource_group_name
            sku = try(ipprefix.sku, null)
            prefix_length = try(ipprefix.prefix_length, null)
            zones = try(ipprefix.zones, null)
            tags = try(ipprefix.tags, null)
        }
    ]), null)
    security_ipprefixes_config_map = try({for ipprefix_config in local.security_ipprefixes_config_flatten : ipprefix_config.name => ipprefix_config}, null)

    // Public IPs (Azure Firewall, Virtual Network Gateway etc)
    security_publicips_config_raw = yamldecode(file(var.security_publicips_yaml_file_path))
    security_publicips_config_flatten = flatten([
        for publicip in local.security_publicips_config_raw : {
            name = publicip.name
            resource_name = publicip.resource_name
            location = publicip.location
            resource_group_name = publicip.resource_group_name
            allocation_method = publicip.allocation_method
            sku = publicip.sku
            ip_version = try(publicip.ip_version, null)
            idle_timeout_in_minutes = try(publicip.idle_timeout_in_minutes, null)
            domain_name_label = try(publicip.domain_name_label, null)
            reverse_fqdn = try(publicip.reverse_fqdn, null)
            public_ip_prefix_name = try(publicip.public_ip_prefix_name, null)
            zones = try(publicip.zones, null)
            tags = try(publicip.tags, null)
        }
    ])
    security_publicips_config_map = {for publicip_config in local.security_publicips_config_flatten : publicip_config.name => publicip_config}


     #// Azure Firewall Base Policies
    security_azurefirewallpols_config_raw = yamldecode(file(var.security_azurefirewallbasepols_yaml_file_path))
    security_azurefirewallpols_config_flatten = flatten([
        for azurefirewallpol in local.security_azurefirewallpols_config_raw : {
            name = azurefirewallpol.name
            location = azurefirewallpol.location
            resource_name = azurefirewallpol.resource_name
            resource_group_name = azurefirewallpol.resource_group_name
            sku = azurefirewallpol.sku
            #base_policy_name = xxxx #// Applies only to child policies - leave as null
            threat_intelligence_mode = azurefirewallpol.threat_intelligence_mode
            threat_intelligence_allowlist = try(azurefirewallpol.threat_intelligence_allowlist,null)
            dns = try(azurefirewallpol.dns,null)
            identity = try(azurefirewallpol.identity, null)
            tls_certificate = try(azurefirewallpol.tls_certificate, null)
            explicit_proxy = try(azurefirewallpol.explicit_proxy, null)
            intrusion_detection = try(azurefirewallpol.intrusion_detection, null)
            insights = try(azurefirewallpol.insights, null)
            tags = try(azurefirewallpol.tags, null)
        }
    ])
    security_azurefirewallpols_config_map_ae = {for azurefirewallpol_config in local.security_azurefirewallpols_config_flatten : azurefirewallpol_config.name => azurefirewallpol_config}

    #// Azure Firewall Child Policies
    security_azurefirewallchildpols_config_raw = yamldecode(file(var.security_azurefirewallchildpols_yaml_file_path))
    security_azurefirewallchildpols_config_flatten = flatten([
        for azurefirewallchildpol in local.security_azurefirewallchildpols_config_raw : {
            name = azurefirewallchildpol.name
            location = azurefirewallchildpol.location
            resource_name = azurefirewallchildpol.resource_name
            resource_group_name = azurefirewallchildpol.resource_group_name
            sku = azurefirewallchildpol.sku
            base_policy_name = azurefirewallchildpol.base_policy_name
            threat_intelligence_mode = azurefirewallchildpol.threat_intelligence_mode
            threat_intelligence_allowlist = try(azurefirewallchildpol.threat_intelligence_allowlist,null)
            dns = try(azurefirewallchildpol.dns,null)
            identity = try(azurefirewallchildpol.identity, null)
            tls_certificate = try(azurefirewallchildpol.tls_certificate, null)
            explicit_proxy = try(azurefirewallchildpol.explicit_proxy, null)
            intrusion_detection = try(azurefirewallchildpol.intrusion_detection, null)
            insights = try(azurefirewallchildpol.insights, null)
            tags = try(azurefirewallchildpol.tags, null)
        }
    ])
    security_azurefirewallchildpols_config_map_ae = {for azurefirewallchildpol_config in local.security_azurefirewallchildpols_config_flatten : azurefirewallchildpol_config.name => azurefirewallchildpol_config}

    #// Azure Firewall Policy Rule Collection Groups - AE
    security_azurefirewallpolrulecollectiongroups_ae_config_raw = yamldecode(file(var.security_azurefirewallpolrulecollectiongroups_ae_yaml_file_path))
    security_azurefirewallpolrulecollectiongroups_ae_config_flatten = flatten([
        for azurefirewallpolrulecollectiongroup in local.security_azurefirewallpolrulecollectiongroups_ae_config_raw : {
            name = azurefirewallpolrulecollectiongroup.name
            resource_name = azurefirewallpolrulecollectiongroup.resource_name
            fw_policy_name = azurefirewallpolrulecollectiongroup.fw_policy_name
            priority = azurefirewallpolrulecollectiongroup.priority
            application_rule_collections = try(azurefirewallpolrulecollectiongroup.application_rule_collections, null)
            network_rule_collections = try(azurefirewallpolrulecollectiongroup.network_rule_collections, null)
            nat_rule_collections = try(azurefirewallpolrulecollectiongroup.nat_rule_collections, null)
            provider = azurefirewallpolrulecollectiongroup.provider
        }
    ])
   security_azurefirewallpolrulecollectiongroups_config_map_ae = {for azurefirewallpolrulecollectiongroup_config in local.security_azurefirewallpolrulecollectiongroups_ae_config_flatten : azurefirewallpolrulecollectiongroup_config.name => azurefirewallpolrulecollectiongroup_config}

}
