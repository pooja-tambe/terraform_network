resource "azurerm_resource_group" "rg" {
  name = "rg-vnet"
  location = "centralus"
}
resource "azurerm_virtual_network" "vnet" {
  name = "dlink"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  address_space = [ "10.0.0.0/16" ]
}

resource "azurerm_subnet" "subnet1" {
  name = "fronsubnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [ "10.0.1.0/24" ]
}

resource "azurerm_subnet" "subnet2" {
  name = "backsubnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [ "10.0.2.0/24" ]
}

resource "azurerm_subnet" "subnet3" {
  name = "backsubnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [ "10.0.3.0/24" ]
}



resource "azurerm_storage_account" "storage" {
  name = "storgafe12789"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  account_replication_type = "LRS"
  account_tier = "Standard"
}


resource "azurerm_network_interface" "nic" {
  name = "my-nic"
  resource_group_name = "rg-vnet"
  location = "centralus"

  ip_configuration {
    name = "Nic-id"
    subnet_id = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}


resource "azurerm_public_ip" "pip" {
    name = "public-IP"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    allocation_method = "Static"

}

resource "azurerm_linux_virtual_machine" "vm" {
  name = "my-vm"
  resource_group_name = "rg-vnet"
  location = "centralus"
  size = "Standard_B1s"
  admin_username = "adminuser"
  admin_password = "password@1234"
  network_interface_ids = azurerm_network_interface.nic.id
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    version   = "latest"
    sku       = "22_04-lts"
  }

}