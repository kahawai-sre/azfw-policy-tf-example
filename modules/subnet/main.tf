
#https://github.com/JamesDLD/terraform-azurerm-Az-VirtualNetwork/blob/master/main.tf
resource "azurerm_subnet" "this" {
  name                                           = var.name
  virtual_network_name                           = var.virtual_network_name
  resource_group_name                            = var.resource_group_name
  address_prefixes                               = var.address_prefixes #// list
  service_endpoints                              = var.service_endpoints #// list
  service_endpoint_policy_ids                    = var.service_endpoint_policy_ids #// List
  private_endpoint_network_policies_enabled  = var.private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled  = var.private_link_service_network_policies_enabled  #// (Optional) Enable or Disable network policies for the private link service on the subnet. Default valule is false. Conflicts with enforce_private_link_endpoint_network_policies.
  dynamic "delegation" {
    for_each = var.delegation == null ? [] : var.delegation
    content {
      name = delegation.value.name
      dynamic "service_delegation" {
        for_each = var.delegation == null ? [] : var.delegation
        content {
          name    = service_delegation.value.service_name == null ? null : service_delegation.value.service_name   # (Required) The name of service to delegate to. Possible values include Microsoft.BareMetal/AzureVMware, Microsoft.BareMetal/CrayServers, Microsoft.Batch/batchAccounts, Microsoft.ContainerInstance/containerGroups, Microsoft.Databricks/workspaces, Microsoft.HardwareSecurityModules/dedicatedHSMs, Microsoft.Logic/integrationServiceEnvironments, Microsoft.Netapp/volumes, Microsoft.ServiceFabricMesh/networks, Microsoft.Sql/managedInstances, Microsoft.Sql/servers, Microsoft.Web/hostingEnvironments and Microsoft.Web/serverFarms.
          actions = service_delegation.value.actions == null ? null : split(",", service_delegation.value.actions)
          #actions = service_delegation.value.actions == null ? null : [for service_action in split(",",service_delegation.value.actions): service_action] # (Required) A list of Actions which should be delegated. Possible values include Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action, Microsoft.Network/virtualNetworks/subnets/action and Microsoft.Network/virtualNetworks/subnets/join/action.
        }
      }
    }
  }
}



