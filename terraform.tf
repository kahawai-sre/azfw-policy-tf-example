terraform {
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~>1.3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.44.1"
    }
  }
  backend "azurerm" {
      resource_group_name = "tf-state"
      storage_account_name = "saaetf"
      container_name = "tfstate"
      key = "terraform-azfw-policy.tfstate"
      subscription_id = "xxxxx-subscription-id-for-tfstate-storage-account"
      tenant_id = "xxxxxx-tenant-id-for-tfstate-storage-account"
  }
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "security"
  subscription_id = var.securitySubscriptionId
  features {}
}

# provider "azapi" {
#     alias           = "connectivity-azapi"
#     subscription_id = var.connectivitySubscriptionId
# }
# provider "azurerm" {
#   alias           = "eulz"
#   subscription_id = var.eulzSubscriptionId
#   features {}
# }
# provider "azurerm" {
#   alias           = "connectivity"
#   subscription_id = var.connectivitySubscriptionId
#   features {}
# }
# provider "azurerm" {
#   alias           = "management"
#   subscription_id = var.managementSubscriptionId
#   features {}
# }
# provider "azurerm" {
#   alias           = "identity"
#   subscription_id = var.identitySubscriptionId
#   features {}
# }
# provider "azurerm" {
#   alias           = "sandbox"
#   subscription_id = var.sandboxSubscriptionId
#   features {}
# }
# provider "azurerm" {
#   alias           = "corpventure0002"
#   subscription_id = var.corpventure0002SubscriptionId
#   features {}
# }
# provider "azurerm" {
#   alias = "online0001"
#   subscription_id =  var.customOnlineSubscriptionId
#   features {}
# }



