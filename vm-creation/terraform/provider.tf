terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.44.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "crgar-migrate-tf-rg"
    storage_account_name = "crgarmigratetfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_azuread_auth     = true
  }
}

provider "azurerm" {
  subscription_id = "96c2852b-cf88-4a55-9ceb-d632d25b83a4"
  storage_use_azuread = true
  features {
  }
}

provider "random" {

}


