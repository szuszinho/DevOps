terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.46.0"
    }
  }

  backend "azurerm" {
    resource_group_name = "DevOps-RG"
    storage_account_name = "tfstatefileacc"
    container_name = "tfstatefilesc"
    key = "terraform.tfstate"
  }
}

provider "azurerm" {
  # Configuration options
  features {
    
  }
}