
output "firewall_id" {
  value       = azurerm_firewall.this.id
}

# output "firewall_private_ip2" {
#   value = azurerm_firewall.this.ip_configuration[0]
# }

# output "firewall_private_ip2" {
#   value = [
#     for index, x in azurerm_firewall.this.ip_configuration:
#     element(azurerm_firewall.this.ip_configuration, x)
#   ]
# }

# output "firewall_private_ip" {
#   value = element([
#     for ipconfig in azurerm_firewall.this.ip_configuration:
#     ipconfig.private_ip_address
#   ],0)
# }

# output "firewall_private_ip3" {
#   value = {
#     for ipconfig in azurerm_firewall.this.ip_configuration:
#     ipconfig.private_ip_address => ipconfig.private_ip_address
#   }
# }


output "virtual_hub_firewall_private_ip" {
  value = try(azurerm_firewall.this.virtual_hub[0].private_ip_address, null)
}

output "virtual_hub_firewall_public_ips" {
  value = try(azurerm_firewall.this.virtual_hub[0].public_ip_addresses,null)
}

# output "merged" {
#   value = [
#     for index, x in azurerm_firewall.this.ip_configuration:
#     merge(x, {"mount_point" = var.mount_point[index]})
#   ]
# }

