provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_esgi" {
  name     = "rg-ESGI-${var.student_name}"
  location = var.ressource_location
}

resource "azurerm_container_registry" "acr_esgi" {
  name                = "acr${var.student_name}"
  resource_group_name = azurerm_resource_group.rg_esgi.name
  location            = azurerm_resource_group.rg_esgi.location
  sku                 = "Standard"
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "aks_esgi" {
  name                = "aks-${var.student_name}"
  location            = azurerm_resource_group.rg_esgi.location
  resource_group_name = azurerm_resource_group.rg_esgi.name
  dns_prefix          = "aks-${var.student_name}"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_public_ip" "public_ip" {
  name                = "public-ip-${var.student_name}"
  resource_group_name = azurerm_resource_group.rg_esgi.name
  location            = azurerm_resource_group.rg_esgi.location
  allocation_method   = "Static"
  sku                 = "Standard"

  depends_on = [azurerm_kubernetes_cluster.aks_esgi]
}

resource "azurerm_role_assignment" "acr_pull_role" {
  scope                = azurerm_container_registry.acr_esgi.id
  principal_id         = azurerm_kubernetes_cluster.aks_esgi.identity[0].principal_id
  role_definition_name = "AcrPull"
  depends_on           = [azurerm_kubernetes_cluster.aks_esgi]
}

resource "azurerm_role_assignment" "acr_push_role" {
  scope                = azurerm_container_registry.acr_esgi.id
  principal_id         = azurerm_kubernetes_cluster.aks_esgi.identity[0].principal_id
  role_definition_name = "AcrPush"
  depends_on           = [azurerm_kubernetes_cluster.aks_esgi]
}
