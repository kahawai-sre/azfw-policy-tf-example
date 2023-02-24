output "vpn_gateway_id" {
  description = "The ID of the VPN Gateway"
  value       = azurerm_vpn_gateway.this.id
}
