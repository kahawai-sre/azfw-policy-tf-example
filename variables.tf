# Stage 1

variable "root_id" {
  type    = string
  default = "eslz-tf"
}

variable "root_name" {
  type    = string
  default = "eslz-tf"
}

variable "securitySubscriptionId" {
  type    = string
  default = "853557d7-xxxxxxxxxxxxxxxxxxxxxxxxxxx"
}

#// Variables below relate to full ESLZ deployment, not just AzFw policy mgmt. Ignore here.

# variable "managementSubscriptionId" {
#   type    = string
#   default = "a84291c3-yyyyyyyyyyyyyyyyyyyyyyyyy"
# }

# variable "connectivitySubscriptionId" {
#   type    = string
#   default = "35bc9ee5-yyyyyyyyyyyyyyyyyyyyyyyyy"
# }

# variable "identitySubscriptionId" {
#   type    = string
#   default = "8fa5f8a1-yyyyyyyyyyyyyyyyyyyyyyyyyy"
# }

# variable "sandboxSubscriptionId" {
#   type    = string
#   default = "48cb5ded-yyyyyyyyyyyyyyyyyyyyyyyyyyy"
# }

# variable "corpventure0002SubscriptionId" {
#   type    = string
#   default = "8f27126c-yyyyyyyyyyyyyyyyyyyyyyyyyy"
# }

# variable "customOnlineSubscriptionId" {
#   type    = string
#   default = "620693f6-yyyyyyyyyyyyyyyyyyyyyyyyyyyy"
# }

# variable "msdn1SubscriptionId" {
#   type    = string
#   default = "29c7e3d4-yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy"
# }

# variable "default_location" {
#   type        = string
#   description = "If specified, will set the Azure region in which region bound resources will be deployed. Please see: https://azure.microsoft.com/en-gb/global-infrastructure/geographies/"
#   default     = "australiaeast"
# }

# variable "primary_location" {
#   type = string
#   default = "australiaeast"
# }

# variable "secondary_location" {
#   type    = string
#   default = "australiasoutheast"
# }

# # Stage 2 - management resources config and deployment

# variable "management_resources_location" {  
#   type    = string  
#   default = "australiaeast"
# }

# variable "management_resources_tags" {  
#   type = map(string)  
#   default = {    
#     BelongsTo = "management"	  
#   }
# } 

# variable "log_retention_in_days" {
#   type    = number
#   default = 50
# }

# variable "security_alerts_email_address" {
#   type    = string
#   default = "justinturver@microsoft.com" 
# }

# # Stage 5 - Connectivity
# variable "connectivity_resources_location" {
#   type    = string
#   default = "australiaeast"
# }

# variable "connectivity_resources_tags" {
#   type = map(string)
#   default = {
#     BelongsTo = "connectivity"
#   }
# }

# variable "fwpolicy_id" {
#   default = "/subscriptions/8fa5f8a1-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/resourceGroups/rg-identity-infosec-fwpolicy-ae/providers/Microsoft.Network/firewallPolicies/fwpol-childpolicy-ae"
# }

