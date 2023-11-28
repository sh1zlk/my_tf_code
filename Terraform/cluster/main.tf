resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name = var.cluster_name
  resource_group_name = var.rg_name
  location = var.rg_location
  dns_prefix = "aks1"

  default_node_pool {
    name       = "default"
    node_count = var.default_node_count
    vm_size    = "Standard_D2_v2"
  }



  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "nodepool_stop" {
  enable_auto_scaling = true
  name = "spot"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  node_count = var.spot_node_count
  max_count = var.spot_node_count
  min_count = 1
  vm_size = "Standard_DS2_v2"
  priority = "Spot"
  os_type = "Linux"
  node_labels = {
    "kubernetes.azure.com/scalesetpriority" = "spot"
  }

  node_taints = [
    "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
  ]


}