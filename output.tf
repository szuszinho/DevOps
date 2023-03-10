output "resource_group_name" {
    value = data.azurerm_resource_group.DevOps_RG.name
}

output "public_ip_address" {
    value = azurerm_linux_virtual_machine.DevOpsVM01.public_ip_address
}

output "tls_private_key" {
    value = tls_private_key.mykey.private_key_pem
    sensitive = true
}