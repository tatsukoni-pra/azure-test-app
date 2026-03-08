terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.54.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tatsukoni-test-v3"
    storage_account_name = "sttatsukonidemotfstate"
    container_name       = "tfstate"
    key                  = "cosmosdb.tfstate"
  }
}

provider "azurerm" {
  subscription_id = "ba29533e-1e4c-43a8-898a-a5815e9b577b"
  features {}
}
