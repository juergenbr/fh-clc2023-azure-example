targetScope = 'subscription'

param rgName string
param location string

module resourcegroup_module 'resourcegroup_module.bicep' = {
  name: 'rg-deployment'
  scope: resourceGroup(rgName)
  params: {
    location: location
  }
}
