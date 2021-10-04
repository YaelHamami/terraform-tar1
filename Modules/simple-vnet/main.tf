resource "azurerm_virtual_network" "sample-vnet" {
  name                = "sample-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.rg-location
  resource_group_name = var.rg-name
}

resource "azurerm_subnet" "sample-subnet" {
  name                 = "sample-subnet"
  resource_group_name  = var.rg-name
  virtual_network_name = azurerm_virtual_network.sample-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "sample-nic" {
  name                = "sample-nic"
  location            = var.rg-location
  resource_group_name = var.rg-name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.sample-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "SampleVM" {
  name                  = "SampleVM"
  location              = var.rg-location
  resource_group_name   = var.rg-name
  network_interface_ids = [azurerm_network_interface.sample-nic.id]
  size                  = "Standard_B2s"

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    name              = "myosdisk-%d"
    caching           = "ReadWrite"
    //managed_disk_type = "Standard_LRS"
    storage_account_type = "Standard_LRS"
  }

  admin_username                  = "testadmin"
  admin_password                  = "Password1234!"
  disable_password_authentication = false
}