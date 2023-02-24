

# resource "azurerm_private_dns_zone_virtual_network_link" "this" {
#   name                    = var.name
#   resource_group_name     = var.resource_group_name #RG where Private DNS zone exists
#   private_dns_zone_name   = var.private_dns_zone_name
#   virtual_network_id      = var.virtual_network_id
#   registration_enabled    = var.registration_enabled
#   tags                    = var.tags #map
# }

# dnsvnetlinks = {
#   "connectivity" = {
#     "/subscriptions/35bc9ee5-7aba-4723-9eac-01b8294344f7/resourceGroups/eslz-tf-dns/providers/Microsoft.Network/privateDnsZones/app1.corp.local/virtualNetworkLinks/29c7e3d4-e589-4555-a1d8-ac60fcc05a2c-0bcb75ea-e2f0-5abf-9090-72f76913bbb5" = {
#       "id" = "/subscriptions/35bc9ee5-7aba-4723-9eac-01b8294344f7/resourceGroups/eslz-tf-dns/providers/Microsoft.Network/privateDnsZones/app1.corp.local/virtualNetworkLinks/29c7e3d4-e589-4555-a1d8-ac60fcc05a2c-0bcb75ea-e2f0-5abf-9090-72f76913bbb5"
#       "name" = "29c7e3d4-e589-4555-a1d8-ac60fcc05a2c-0bcb75ea-e2f0-5abf-9090-72f76913bbb5"
#       "private_dns_zone_name" = "app1.corp.local"
#       "registration_enabled" = false
#       "resource_group_name" = "eslz-tf-dns"
#       "tags" = tomap({
#         "deployedBy" = "terraform/azure/caf-enterprise-scale/v2.0.0"
#       })
#       "timeouts" = null /* object */
#       "virtual_network_id" = "/subscriptions/29c7e3d4-e589-4555-a1d8-ac60fcc05a2c/resourceGroups/rg-vpnhome/providers/Microsoft.Network/virtualNetworks/vnet-onprem"
#     }
#     "/subscriptions/35bc9ee5-7aba-4723-9eac-01b8294344f7/resourceGroups/eslz-tf-dns/providers/Microsoft.Network/privateDnsZones/app1.corp.local/virtualNetworkLinks/35bc9ee5-7aba-4723-9eac-01b8294344f7-93395dc1-3d9c-5de1-9185-fb6312c728c0" = {
#       "id" = "/subscriptions/35bc9ee5-7aba-4723-9eac-01b8294344f7/resourceGroups/eslz-tf-dns/providers/Microsoft.Network/privateDnsZones/app1.corp.local/virtualNetworkLinks/35bc9ee5-7aba-4723-9eac-01b8294344f7-93395dc1-3d9c-5de1-9185-fb6312c728c0"
#       "name" = "35bc9ee5-7aba-4723-9eac-01b8294344f7-93395dc1-3d9c-5de1-9185-fb6312c728c0"
#       "private_dns_zone_name" = "app1.corp.local"
#       "registration_enabled" = false
#       "resource_group_name" = "eslz-tf-dns"
#       "tags" = tomap({
#         "deployedBy" = "terraform/azure/caf-enterprise-scale/v2.0.0"
#       })
#       "timeouts" = null /* object */
#       "virtual_network_id" = "/subscriptions/35bc9ee5-7aba-4723-9eac-01b8294344f7/resourceGroups/rg-connectivity-sharedservices-ae/providers/Microsoft.Network/virtualNetworks/vnet-connectivity-sharedservices-ae"
#     }


locals {
    // Map of Private DNS Zone vnet links to update ...
    connectivity_vnetlinks_to_update_config_raw = yamldecode(file(var.connectivity_vnetlinks_to_update_yaml_file_path))
    connectivity_vnetlinks_to_update_config_flatten = flatten([
        for vnetlink in local.connectivity_vnetlinks_to_update_config_raw : {
            name = vnetlink.name #<= equals Private DNS ZOne name which will be the key in map for cross referencing with data source
            virtual_network_id = vnetlink.virtual_network_id
            private_dns_zone_name = vnetlink.private_dns_zone_name
            registrationEnabled = vnetlink.registrationEnabled
        }
    ])
    connectivity_vnetlinks_to_update_config_map = {for vnetlinks_to_update_config in local.connectivity_vnetlinks_to_update_config_flatten : vnetlinks_to_update_config.name => vnetlinks_to_update_config}
}

resource "azapi_update_resource" "this" {
  # Filter IN only those records that match the locally defined vnetlinks from YAML/connectivity_vnetlinks_to_update_config_map
  for_each = {
    for vnetlink, vnetlinkconfig in local.connectivity_vnetlinks_to_update_config_map : vnetlink => vnetlinkconfig
    if vnetlinkconfig.private_dns_zone_name == var.private_dns_zone_name && vnetlinkconfig.virtual_network_id == var.virtual_network_id
  }
  type        = "Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01"
  resource_id = var.vnetlink_resource_id
  body = jsonencode({
    properties = {
      registrationEnabled = each.value.registrationEnabled
    }
  })
}



# resource "null_data_resource" "test" {
#   for_each = {
#     for vnetlink, vnetlinkconfig in local.connectivity_vnetlinks_to_update_config_map : vnetlink => vnetlinkconfig
#     if vnetlinkconfig.private_dns_zone_name == each.value.private_dns_zone_name && vnetlinkconfig.virtual_network_id == each.value.virtual_network_id
#   }
#     ? 
#   inputs = {
#     virtual_network_id = each.value.virtual_network_id
#     vnetlink_resource_id = each.value.vnetlink_resource_id
#     private_dns_zone_name = each.value.
#   }
# }

# variable "mymap" {
#     type = map(object({
#         attribute = string
#         condition = bool
#     }))

#     default = {
#         key1 = {
#             attribute = "value"
#             condition = true
#         }
#         key2 = {
#             attribute = "value"
#             condition = false
#         }
#         key3 = {
#             attribute = "value"
#             condition = true
#         }
#     }
# }

# resource "null_resource" "test" {
#   for_each = { for k in compact([for k, v in var.mymap: v.condition ? k : ""]): k => var.mymap[k] }
# }

# users = {
#   "testterform" = {
#     path          = "/"
#     force_destroy = true
#     email_address = "testterform@example.com"
#     group_memberships = [ "test1" ]
#     tags = { department : "test" }
#     ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAA4l7"
#   }

#   "testterform2" = {
#     path          = "/"
#     force_destroy = true
#     email_address = "testterform2@example.com"
#     group_memberships = [ "test1" ]
#     tags = { department : "test" }
#     ssh_public_key = ""
#   }

# resource "aws_iam_user_ssh_key" "this" {
#   for_each = {
#     for name, user in var.users : name => user
#     if user.ssh_public_key != ""
#   }

#   username   = each.key
#   encoding   = "SSH"
#   public_key = each.value.ssh_public_key

#   depends_on = [aws_iam_user.this]
# }