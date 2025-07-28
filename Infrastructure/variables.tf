variable "client_id" {
  description = "The Client ID of the Azure Service Principal"
  type        = string
}

variable "client_secret" {
  description = "The Client Secret of the Azure Service Principal"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "The Tenant ID of the Azure Service Principal"
  type        = string
}

variable "subscription_id" {
  description = "The Azure Subscription ID"
  type        = string
}
variable "azure_region" {
  description = "Azure region"
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Azure Resource Group name"
  default     = "jenkins-ansible-rg"
}

variable "admin_username" {
  description = "Admin username for VMs"
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password for VMs"
  default     = "Dev123ops" # Change in production!
  sensitive   = true
}

variable "vm_size" {
  description = "VM size"
  default     = "Standard_B2s"
}