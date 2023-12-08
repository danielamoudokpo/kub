output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks_esgi.name
}

output "resource_group_name" {
  value = azurerm_resource_group.rg_esgi.name
}

output "public_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}
