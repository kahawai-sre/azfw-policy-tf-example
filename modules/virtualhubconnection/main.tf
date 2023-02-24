resource "azurerm_virtual_hub_connection" "this" {
  name                          = var.name
  virtual_hub_id                = var.virtual_hub_id
  remote_virtual_network_id     = var.remote_virtual_network_id
  internet_security_enabled     = var.internet_security_enabled
  #hub_to_vitual_network_traffic_allowed = var.hub_to_vitual_network_traffic_allowed

  dynamic "routing" {
    for_each = var.routing != null ? var.routing  : []
    content {
        associated_route_table_id = routing.value.associated_route_table
        dynamic "propagated_route_table" {
          for_each = routing.value.propagated_route_table == null ? [] : routing.value.propagated_route_table
          content {
            route_table_ids = try(propagated_route_table.value.route_table_ids, null)
            labels = try(propagated_route_table.value.labels, null)
          }
        }
    }
  }
}