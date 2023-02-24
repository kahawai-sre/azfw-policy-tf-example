variable "name" {
}

variable "resource_group_name" {
}

variable "location" {
}

variable "address_space" {
  type = list(string)
}

# If no values specified, this defaults to Azure DNS 
variable "dns_servers" {
  type = list(string)
  default     = null
}

variable "ddos_protection_plan_name" {
    description = "If DDoS standard is to be enabled, this should be poplated with the associated DDoS protection plan name mapping to the plan resource ID"
    default = null
}

variable "ddos_protection_plan_location" {
    description = "If DDoS standard is to be enabled, this should be poplated with the associated DDoS protection plan name location"
    default = null
}

variable "ddos_protection_plan_resourcegroup_name" {
    description = "If DDoS standard is to be enabled, this should be poplated with the associated DDoS protection plan resource group"
    default = null
}

/*
variable "ddos_protection_plan_id" {
    description = "If DDoS standard is to be enabled, this should be populated with the associated DDoS protection plan resource ID ID"
    default = null
}
*/

/*

variable "ddos_protection_plan" {
    description = "Map containing two values?: id (the resource ID of the DDOS plan), enable (boolean true or false)"
    type        = map(string,bool)
    default = null
}

ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.example.id
    enable = true
}
*/

variable "bgp_community" {
  description = "The BGP community attribute in format <as-number>:<community-value>"
  default = null
}

# variable "vm_protection_enabled" {
#   default = null
# }

variable "tags" {
  type        = map(string)
  default = null
}
/*
variable "tags" {
  type        = map(string)
  default = null

  default = {
    tag1 = ""
    tag2 = ""
  }
}

variable "subnet_prefixes" {
  description = "The address prefix to use for the subnet."
  default     = ["10.0.1.0/24"]
}

variable "subnet_names" {
  description = "A list of public subnets inside the vNet."
  default     = ["subnet1"]
}
*/