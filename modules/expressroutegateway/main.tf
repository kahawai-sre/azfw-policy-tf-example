resource "azurerm_express_route_gateway" "this" {
  name                              = var.name
  location                          = var.location
  resource_group_name               = var.resource_group_name
  virtual_hub_id                    = var.virtual_hub_id
  scale_units                        = var.scale_units

}