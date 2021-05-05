variable "azurerm_resource_group_name" {
  type = string
}

variable "azurerm_resource_group_location" {
  type = string
}

variable "project_name" {
  type = string
}

resource "azurerm_container_registry" "acr" {
  name                     = "${var.project_name}acr"
  resource_group_name      = var.azurerm_resource_group_name
  location                 = var.azurerm_resource_group_location
  sku                      = "Basic"
  admin_enabled            = false
}

output "azurerm_container_registry_id" {
  value = azurerm_container_registry.acr.id
}