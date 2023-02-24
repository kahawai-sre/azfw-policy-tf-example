
resource "azurerm_vpn_gateway_connection" "this" {
  name               = var.name
  vpn_gateway_id     = var.vpn_gateway_id
  remote_vpn_site_id = var.remote_vpn_site_id

# A routing block supports the following:
# associated_route_table - (Required) The ID of the Route Table associated with this VPN Connection.
# propagated_route_table - (Required) A propagated_route_table block as defined below.
  # A propagated_route_table block supports the following:
  # route_table_ids - (Required) A list of Route Table ID's to associated with this VPN Gateway Connection.
  # labels - (Optional) A list of labels to assign to this route table

  # - name: "vpngwconnection-vpnsite-home-ae"
  # location: "australiaeast"
  # resource_group_name: "rg-vnet-sharedservices-hub-prod"
  # #vpn_gateway_name: "vpngw-vwan-hub-sharedservices-ae-prod" #maps to vpn gateway id
  # vpn_gateway_name: "/subscriptions/35bc9ee5-7aba-4723-9eac-01b8294344f7/resourceGroups/contoso-connectivity/providers/Microsoft.Network/vpnGateways/contoso-vpngw-australiaeast" # sub-in Id here until eslz module outputs the vWan Id and can be referenced by name
  # remote_vpn_site_name: "vpnsite-home-ae" #maps to vpn site id
  # vpn_link_name: "vpnhome01" #maps to vpn site link id
  # vpn_link_bgp_enabled: "true"
  # vpn_link_protocol: "IKEv2"
  # vpn_link_local_azure_ip_address_enabled: "true"
  # vpn_site_link_name: "vpnhome01"
  # routing: #blocks
  # - name: ""
  #   associated_route_table: "/subscriptions/35bc9ee5-7aba-4723-9eac-01b8294344f7/resourceGroups/contoso-connectivity/providers/Microsoft.Network/virtualHubs/contoso-hub-australiaeast/hubRouteTables/defaultRouteTable"
  #   propagated_route_table: #block
  #   - route_table_ids: ["/subscriptions/35bc9ee5-7aba-4723-9eac-01b8294344f7/resourceGroups/contoso-connectivity/providers/Microsoft.Network/virtualHubs/contoso-hub-australiaeast/hubRouteTables/noneRouteTable"]
  #     labels: []

  dynamic "routing" {
    for_each = var.routing != null ? var.routing  : []
    content {
        associated_route_table = routing.value.associated_route_table # Id of Route Table to propagate to
        dynamic "propagated_route_table" {
          for_each = routing.value.propagated_route_table == null ? [] : routing.value.propagated_route_table
          content {
            route_table_ids = try(propagated_route_table.value.route_table_ids, null)
            labels = try(propagated_route_table.value.labels, null)
          }
        }
    }
  }

  vpn_link {
    name = var.vpn_link_name
    vpn_site_link_id = var.vpn_site_link_id
    bgp_enabled = var.vpn_link_bgp_enabled
    protocol = var.vpn_link_protocol
  }
  lifecycle {
    ignore_changes = [ vpn_link[0].shared_key ]
  }
}