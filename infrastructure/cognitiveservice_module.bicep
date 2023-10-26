param location string
var connections_cognitiveservicescomputervision_name = 'cognitiveservicescomputervision-1'
var accounts_fhclc3excompvis_name = 'fhclc3excompvis-${uniqueString(resourceGroup().id)}'
var accounts_fhclc3excustvis_name = 'fhclc3excustvis${uniqueString(resourceGroup().id)}'
var accounts_fhclc3excustvis_pred_name = 'fhclc3excustvis${uniqueString(resourceGroup().id)}pred'

resource connections_cognitiveservicescomputervision_name_resource 'Microsoft.Web/connections@2016-06-01' = {
  name: connections_cognitiveservicescomputervision_name
  location: location
  properties: {
    displayName: 'fh-clc3-compvision-key'
    statuses: [
      {
        status: 'Connected'
      }
    ]
    customParameterValues: {}
    createdTime: '2022-08-15T17:38:34.6278427Z'
    changedTime: '2022-08-15T17:49:07.9456582Z'
    api: {
      name: 'cognitiveservicescomputervision'
      displayName: 'Computer Vision API'
      description: 'Extrahieren Sie umfangreiche Informationen aus Bildern, um visuelle Daten zu kategorisieren und zu verarbeiten, und schützen Sie Ihre Benutzer mit Azure Cognitive Service vor unerwünschten Inhalten.'
      iconUri: 'https://connectoricons-prod.azureedge.net/releases/v1.0.1549/1.0.1549.2680/cognitiveservicescomputervision/icon.png'
      brandColor: '#1267AE'
      id: '${subscription().id}/providers/Microsoft.Web/locations/westeurope/managedApis/cognitiveservicescomputervision'
      type: 'Microsoft.Web/locations/managedApis'
    }
    testLinks: [
      {
        requestUri: '${environment().resourceManager}:443${subscription().id}/resourceGroups/rg-fh-clc3-example/providers/Microsoft.Web/connections/${connections_cognitiveservicescomputervision_name}/extensions/proxy/vision/v2.0/models?api-version=2016-06-01'
        method: 'get'
      }
    ]
  }
}

resource accounts_fhclc3excompvis_name_resource 'Microsoft.CognitiveServices/accounts@2022-03-01' = {
  name: accounts_fhclc3excompvis_name
  location: location
  sku: {
    name: 'F0'
  }
  kind: 'ComputerVision'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    customSubDomainName: accounts_fhclc3excompvis_name
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    publicNetworkAccess: 'Enabled'
  }
}

resource customvision_training 'Microsoft.CognitiveServices/accounts@2022-03-01' = {
  name: accounts_fhclc3excustvis_name
  location: location
  sku: {
    name: 'F0'
  }
  kind: 'CustomVision.Training'
  properties: {
    customSubDomainName: accounts_fhclc3excustvis_name
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    publicNetworkAccess: 'Enabled'
  }
}

resource customvision_prediction 'Microsoft.CognitiveServices/accounts@2022-03-01' = {
  name: accounts_fhclc3excustvis_pred_name
  location: location
  sku: {
    name: 'F0'
  }
  kind: 'CustomVision.Prediction'
  properties: {
    customSubDomainName: accounts_fhclc3excustvis_pred_name
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    publicNetworkAccess: 'Enabled'
  }
}

output connections_cognitiveservicescomputervision_name_resource_id string = connections_cognitiveservicescomputervision_name_resource.id
output cognitiveService_name string = accounts_fhclc3excompvis_name_resource.name
output customvision_training_name string = customvision_training.name
output customvision_prediction_name string = customvision_prediction.name
