output "vpnsite_id" {
  description = "The ID of the VPN Site"
  value       = azurerm_vpn_site.this.id
}

output "vpnsite_link" {
  description = "The Link of the VPN site"
  value       = azurerm_vpn_site.this.link
}
