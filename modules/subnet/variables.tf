
variable "name" {
}

variable "resource_group_name" {
}


variable "virtual_network_name" {
}

variable "address_prefixes" { 
    type = list(string)
}

variable "service_endpoints" {
  type = list(string)
  default     = null
}

variable "service_endpoint_policy_ids" {
  type = list(string)
  default     = null
}

variable "private_endpoint_network_policies_enabled" {
  type = bool
  default = null
}

variable "private_link_service_network_policies_enabled" {
    type = bool
    default = null
}

variable "delegation" {
    # type = object({
    #   actions = string
    #   name = string
    #   service_name = string
    # })
    type = any
    default = null
}

# type = list(object({
#     actions = string
#     name = string
#     service_name = string
#   })
# )

# "AzureFirewallSubnet" = {
#     "address_prefixes" = "10.0.0.0/24"
#     "enforce_private_link_endpoint_network_policies" = false
#     "enforce_private_link_service_network_policies" = false
#     "name" = "AzureFirewallSubnet"
#     "resource_group_name" = "rg-vnet-sharedservices-hub"
#     "service_delegations" = [
#       {
#         "actions" = "Microsoft.Network/networkinterfaces/*,Microsoft.Network/virtualNetworks/subnets/action"
#         "name" = "appservice"
#         "service_name" = "Microsoft.Web/serverFarms"
#       },
#     ]
#     "service_endpoints" = null
#     "virtual_network_name" = "vnet-sharedservices-hub"
