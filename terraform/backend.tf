terraform {
  required_version = "~> 1.13.0"
#moving de backend to local
#  backend "azurerm" {
#    resource_group_name  = "rg-moviesterra-tfstate"
#    storage_account_name = "stmoviesstate02eb9e"
#    container_name       = "tfstate"
#    key                  = "terraform.tfstate"
#  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}