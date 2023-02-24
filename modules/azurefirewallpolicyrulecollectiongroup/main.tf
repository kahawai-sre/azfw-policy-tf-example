#https://github.com/JamesDLD/terraform-azurerm-Az-VirtualNetwork/blob/master/main.tf

# key_exists = contains(keys(map), key)
# key_exists = lookup(map, key, default) != default
resource "azurerm_firewall_policy_rule_collection_group" "this" {
  name                                           = var.name
  firewall_policy_id                             = var.firewall_policy_id
  priority                                       = var.priority        
  dynamic "application_rule_collection" {
    for_each = var.application_rule_collection == null ? [] : var.application_rule_collection
    content {
      name = application_rule_collection.value.name
      priority = application_rule_collection.value.priority
      action = application_rule_collection.value.action
      dynamic "rule" {
        for_each = application_rule_collection.value.rules == null ? [] : application_rule_collection.value.rules
        content {
          name = rule.value.name
          source_addresses = try(rule.value.source_addresses, null)
          source_ip_groups = try(rule.value.source_ip_groups, null)
          destination_fqdns = try(rule.value.destination_fqdns, null)
          destination_fqdn_tags = try(rule.value.destination_fqdn_tags, null)
          dynamic "protocols" {
            for_each = rule.value.protocols
            content {
              type = protocols.value.type
              port = protocols.value.port
            }
          }
        }
      }
    }
  }
  dynamic "network_rule_collection" {
    for_each = var.network_rule_collection == null ? [] : var.network_rule_collection
    content {
      name = network_rule_collection.value.name
      priority = network_rule_collection.value.priority
      action = network_rule_collection.value.action
      dynamic "rule" {
        for_each = network_rule_collection.value.rules == null ? [] : network_rule_collection.value.rules
        content {
          name = rule.value.name
          protocols = rule.value.protocols
          source_addresses = try(rule.value.source_addresses, null)
          source_ip_groups = try(rule.value.source_ip_groups, null)
          destination_addresses = try(rule.value.destination_addresses, null)
          destination_ip_groups = try(rule.value.destination_ip_groups, null)
          destination_fqdns = try(rule.value.destination_fqdns, null)
          destination_ports = rule.value.destination_ports
        }
      }
    }
  }
  dynamic "nat_rule_collection" {
    for_each = var.nat_rule_collection == null ? [] : var.nat_rule_collection
    content {
      name = nat_rule_collection.value.name
      priority = nat_rule_collection.value.priority
      action = nat_rule_collection.value.action
      dynamic "rule" {
        for_each = nat_rule_collection.value.rules == null ? [] : nat_rule_collection.value.rules
        content {
          name = rule.value.name
          protocols = rule.value.protocols
          translated_address = rule.value.translated_address
          translated_port = rule.value.translated_port
          source_addresses = try(rule.value.source_addresses, null)
          source_ip_groups = try(rule.value.source_ip_groups, null)
          destination_address = try(rule.value.destination_address, null)
          destination_ports = try(rule.value.destination_ports, null)
        }
      }
    }
  }
}

/*
- name: "fwpol-rcg-test"
  resource_name: "fwpol-rcg-test"
  fw_policy_name: "fwpol-basepolicy" # Maps to 'firewall_policy_id'
  priority: "500"
  application_rule_collections: #blocks
    - name: "apprules-core-allow"
      priority: "500" 
      action: "Allow"
      rules: #blocks
      - name: "allow-management-urls"
        protocols: #'protocol' is a block
          - type: "https" 
            port: "443"
          - type: "http"
            port: "80" 
        source_addresses: ["*"] # list
        source_ip_groups_names: # list, maps to "source_ip_groups"
        destination_fqdns: ["*.microsoft.com"] # list
        destination_fqdn_tags: ["AppServiceEnvironment","WindowsUpdate","AzureMonitor"] # list
      - name: "allow-demoapp-apis"
        protocols: 
          - type: "https" ## 'protocol' is a block
            port: "443"
        source_addresses: ["10.0.0.0/16","10.1.0.0/16","10.100.0.0/16"] # list
        destination_fqdns: ["testapi.api.apicentre.demoapp2.co.nz"] # list
  network_rule_collections: #blocks
    - name: "networkrules-core-allow"
      priority: "400" 
      action: "Allow"
      rules: #blocks
      - name: "allow-azurebastion-to-spokes"
        protocols: ["TCP"] # Any, TCP, UDP, ICMP - list
        source_addresses: ["10.0.2.0/24"] # list
        source_ip_groups_names: # list, maps to "source_ip_groups"
        destination_addresses: ["10.1.0.0/16","10.100.0.0/16"] # list, split by ',' to enumerate
        destination_ip_groups: # List
        destination_fqdns: # List
        destination_ports: ["22","3389"]
      - name: "allow-azurebastion-to-control-plane"
        protocols: "TCP" # Any, TCP, UDP, ICMP - List
        source_addresses: ["10.0.2.0/24"] # list
        source_ip_groups: # list of names of source IP group names
        destination_addresses: ["AzureCloud"]
        destination_ip_groups: # list of names of target IP group names
        destination_fqdns: # list
        destination_ports: ["443"] #list
  nat_rule_collections: #blocks
    - name: "natrules-core-allow"
      priority: "300" 
      action: "Dnat" # Only 'Dnat', implies allow
      rules: #blocks
      - name: "allow-azurebastion-to-control-plane"
        protocols: ["TCP"] # TCP, UDP, ICMP - List
        translated_address: "10.200.4.10" # Target IP for DNAT
        translated_port: "443" # Target port for DNAT  
        source_addresses: ["200.10.10.10"] # list, split by ',' to enumerate
        source_ip_groups: # list of names of source IP group names
        destination_address_public_ip_name: "pip-azfw-ae-2" #/ Name of Public IP resource that has the desired Listener IP (external IP on firewall) - maps to "destination_address" - the public IP address assigned to this Public IP resource
        destination_ports: "8443" # List - external ports that DNAT is listening @ on 'destination_address'
*/