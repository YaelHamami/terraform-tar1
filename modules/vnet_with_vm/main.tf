resource "azurerm_virtual_network" "sample_vnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_address]
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "sample_subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.sample_vnet.name
  address_prefixes     = [var.subnet_address]
}

resource "azurerm_public_ip" "sample_public_ip" {
  name                = var.public_ip_name
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "sample_nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.sample_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.sample_public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "sample_vm" {
  computer_name         = var.vm_name
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.rg_name
  network_interface_ids = [azurerm_network_interface.sample_nic.id]
  size                  = "Standard_B2s"

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    name                 = "myosdisk${var.vm_name}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_username                  = "testadmin"
  admin_password                  = "Password1234!"
  disable_password_authentication = false
}