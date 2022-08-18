param deploymentName string
param rgName string
param location string

targetScope = 'subscription'

module subscription_module 'subscription_module.bicep' = {
  name: deploymentName
  scope: subscription()
  params: {
    location: location
    rgName: rgName
  }
}
