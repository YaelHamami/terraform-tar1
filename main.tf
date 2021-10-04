# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "d94fe338-52d8-4a44-acd4-4f8301adf2cf"
}

resource "azurerm_resource_group" "targil_rg" {
  name     = "targil_rg"
  location = "West Europe"
}

module "vnet_and_vm1" {
  source = "./modules/vnet_with_vm"

  rg_name  = azurerm_resource_group.targil_rg.name
  location = azurerm_resource_group.targil_rg.location

  vnet_address   = "10.0.0.0/16"
  vnet_name      = "sample_vnet1"
  subnet_address = "10.0.2.0/24"
  subnet_name    = "subnet1"

  nic_name       = "sample_nic1"
  public_ip_name = "public_ip_vm1"
  vm_name        = "sampleVm1"

  depends_on = [azurerm_resource_group.targil_rg]
}

module "vnet_and_vm2" {
  source = "./modules/vnet_with_vm"

  rg_name  = azurerm_resource_group.targil_rg.name
  location = azurerm_resource_group.targil_rg.location

  vnet_address   = "10.1.0.0/16"
  vnet_name      = "sample_vnet2"
  subnet_address = "10.1.2.0/24"
  subnet_name    = "subnet2"

  nic_name       = "sample_nic2"
  public_ip_name = "public_ip_vm2"
  vm_name        = "sampleVm2"

  depends_on = [azurerm_resource_group.targil_rg]
}

resource "azurerm_virtual_network_peering" "peer1to2" {
  name                      = "peer1to2"
  resource_group_name       = azurerm_resource_group.targil_rg.name
  virtual_network_name      = module.vnet_and_vm1.vnet_name
  remote_virtual_network_id = module.vnet_and_vm2.vnet_id

  depends_on = [module.vnet_and_vm1, module.vnet_and_vm2]
}


