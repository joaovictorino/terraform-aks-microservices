variable "azurerm_resource_group_name" {
  type = string
}

variable "azurerm_resource_group_location" {
  type = string
}

variable "appId" {
  type = string
}

variable "password" {
  type = string
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "teste-aks"
  location            = var.azurerm_resource_group_location
  resource_group_name = var.azurerm_resource_group_name
  dns_prefix          = "teste-k8s"
  http_application_routing_enabled = true
  role_based_access_control_enabled = true

  default_node_pool {
    name            = "default"
    node_count      = 3
    vm_size         = "Standard_D3_v2"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }
}