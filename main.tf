data "azurerm_resource_group" "DevOps_RG" {
    name = "DevOps-RG"
}

data "azurerm_storage_account" "tfstatefileacc" {
    name = "tfstatefileacc"
    resource_group_name = data.azurerm_resource_group.DevOps_RG.name
}

data "azurerm_storage_container" "tfstatefilesc" {
    name = "tfstatefilesc"
    storage_account_name = data.azurerm_storage_account.tfstatefileacc.name
}

resource "azurerm_virtual_network" "DevOps_VN" {
    name = "DevOPS_VN"
    address_space = [ "10.0.0.0/16" ]
    location = data.azurerm_resource_group.DevOps_RG.location
    resource_group_name = data.azurerm_resource_group.DevOps_RG.name
}

resource "azurerm_subnet" "DevOps_SN" {
    name = "DevOps_SN"
    resource_group_name = data.azurerm_resource_group.DevOps_RG.name
    virtual_network_name = azurerm_virtual_network.DevOps_VN.name
    address_prefixes = [ "10.0.1.0/24" ]
}

resource "azurerm_public_ip" "DevOps_PIP" {
    name = "DevOps_PIP"
    resource_group_name = data.azurerm_resource_group.DevOps_RG.name
    location = data.azurerm_resource_group.DevOps_RG.location
    allocation_method = "Static"
}

resource "azurerm_network_interface" "DevOps_NIC" {
    name = "DevOps_NIC"
    location = data.azurerm_resource_group.DevOps_RG.location
    resource_group_name = data.azurerm_resource_group.DevOps_RG.name

    ip_configuration {
      name = "internal"
      subnet_id = azurerm_subnet.DevOps_SN.id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.DevOps_PIP.id
    }
}

resource "azurerm_network_security_group" "DevOps_NSG" {
    name = "DevOps_NSG"
    location = data.azurerm_resource_group.DevOps_RG.location
    resource_group_name = data.azurerm_resource_group.DevOps_RG.name

    security_rule {
        name = "SSH"
        priority = 1001
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name = "Dashboard"
        priority = 1002
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "8080"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    } 
}

resource "azurerm_network_interface_security_group_association" "DevOps_SGA" {
    network_interface_id = azurerm_network_interface.DevOps_NIC.id
    network_security_group_id = azurerm_network_security_group.DevOps_NSG.id
}

resource "tls_private_key" "mykey" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "azurerm_linux_virtual_machine" "DevOpsVM01" {
    name = "DevOpsVM01"
    resource_group_name = data.azurerm_resource_group.DevOps_RG.name
    location = data.azurerm_resource_group.DevOps_RG.location
    size = "Standard_D2_v3"
    admin_username = var.vm_username
    disable_password_authentication = true
    network_interface_ids = [ azurerm_network_interface.DevOps_NIC.id, ]
    admin_ssh_key {
      username = var.vm_username
      public_key = tls_private_key.mykey.public_key_openssh
    }

    priority = "Spot"
    eviction_policy = "Deallocate"

    os_disk {
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }

    source_image_reference {
      publisher = var.vm_publisher
      offer = var.vm_offer
      sku = var.vm_sku
      version = var.vm_version
    }
}
