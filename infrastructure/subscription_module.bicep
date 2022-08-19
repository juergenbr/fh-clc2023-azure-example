targetScope = 'subscription'

param rgName string
param location string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}

module resourcegroup_module 'resourcegroup_module.bicep' = {
  name: 'rg-deployment'
  scope: resourceGroup
  params: {
    location: location
  }
}
