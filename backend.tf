terraform {
  backend "azurerm" {
    storage_account_name = "tcterraformstate"
    container_name       = "tfstate"
    key                  = "state-test2.tf"

    // NOTE: this requires ARM_ACCESS_KEY environment variable to be set
  }
}
