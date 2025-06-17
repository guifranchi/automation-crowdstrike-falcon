# variables.tf
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-crowdstrike-falcon"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "prefix" {
  description = "Prefix for all resources"
  type        = string
  default     = "falcon"
}

variable "linux_vm_size" {
  description = "Size of the Linux VM"
  type        = string
  default     = "Standard_B1s"
}

variable "windows_vm_size" {
  description = "Size of the Windows VM"
  type        = string
  default     = "Standard_B1ms"
}

variable "linux_admin_username" {
  description = "Admin username for Linux VM"
  type        = string
  default     = "azureuser"
}

variable "linux_admin_password" {
  description = "Admin password for Linux VM"
  type        = string
  sensitive   = true
}

variable "windows_admin_username" {
  description = "Admin username for Windows VM"
  type        = string
  default     = "azureuser"
}

variable "windows_admin_password" {
  description = "Admin password for Windows VM"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Development"
    Project     = "CrowdStrike-Falcon"
    ManagedBy   = "Terraform"
  }
}

