provider "azurerm" {
  features {}
  subscription_id = "63e35d6a-7835-4a9c-8b0c-54ced3a1e648"
  client_id       = "8f3cff5b-228d-4d15-9614-1ab8196054f9"
  client_secret   = "HPC8Q~tK4xXRIMtUavLqctlRu0633dq~mBJn3aw7"
  tenant_id       = "9828e304-c540-44b4-851d-f10b480f67ce"
}

resource "azurerm_resource_group" "aks_rg" {
  name     = "aks-resource-group"
  location = "Canada Central"
}

resource "azurerm_virtual_network" "aks_vnet" {
  name                = "aks-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name   = azurerm_resource_group.aks_rg.name
  virtual_network_name  = azurerm_virtual_network.aks_vnet.name
  address_prefixes      = ["10.0.1.0/24"]
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "my-aks-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "myaks"

  default_node_pool {
    name       = "agentpool"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    service_cidr    = "10.0.2.0/24"
    dns_service_ip  = "10.0.2.10"
  }
}

