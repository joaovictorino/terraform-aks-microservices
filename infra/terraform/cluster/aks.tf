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

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  role_based_access_control {
    enabled = true
  }

  addon_profile {
    http_application_routing {
      enabled = true
    }
  }
}