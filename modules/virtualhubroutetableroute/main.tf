
resource "azurerm_virtual_hub_route_table_route" "this" {
  name              = var.name
  route_table_id    = var.route_table_name
  destinations_type = var.destinations_type  # "CIDR"
  destinations      = var.destinations       #["10.0.0.0/16"]
  next_hop_type     = var.next_hop_type       #"ResourceId"
  next_hop          = var.next_hop          #azurerm_virtual_hub_connection.example.id, Azure Firewall Resource Id, VPN gateway Resource Id, etc
}
