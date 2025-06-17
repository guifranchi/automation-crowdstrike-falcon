# outputs.tf
output "linux_public_ip" {
  description = "Public IP address of the Linux VM"
  value       = azurerm_public_ip.linux.ip_address
}

output "windows_public_ip" {
  description = "Public IP address of the Windows VM"
  value       = azurerm_public_ip.windows.ip_address
}

output "linux_vm_name" {
  description = "Name of the Linux VM"
  value       = azurerm_linux_virtual_machine.main.name
}

output "windows_vm_name" {
  description = "Name of the Windows VM"
  value       = azurerm_windows_virtual_machine.main.name
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "linux_ssh_connection" {
  description = "SSH connection command for Linux VM"
  value       = "ssh ${var.linux_admin_username}@${azurerm_public_ip.linux.ip_address}"
}

output "windows_rdp_connection" {
  description = "RDP connection info for Windows VM"
  value       = "RDP to ${azurerm_public_ip.windows.ip_address}:3389"
}

