param location string
var connections_cognitiveservicescomputervision_name = 'cognitiveservicescomputervision-1'
var accounts_fhclc3excompvis_name = 'fhclc3excompvis-${uniqueString(resourceGroup().id)}'

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
    customParameterValues: {
    }
    createdTime: '2022-08-15T17:38:34.6278427Z'
    changedTime: '2022-08-15T17:49:07.9456582Z'
    api: {
      name: 'cognitiveservicescomputervision'
      displayName: 'Computer Vision API'
      description: 'Extrahieren Sie umfangreiche Informationen aus Bildern, um visuelle Daten zu kategorisieren und zu verarbeiten, und schützen Sie Ihre Benutzer mit Azure Cognitive Service vor unerwünschten Inhalten.'
      iconUri: 'https://connectoricons-prod.azureedge.net/releases/v1.0.1549/1.0.1549.2680/cognitiveservicescomputervision/icon.png'
      brandColor: '#1267AE'
      id: '/subscriptions/c0a97786-cce2-4cf3-9f1a-022e775c19ad/providers/Microsoft.Web/locations/westeurope/managedApis/cognitiveservicescomputervision'
      type: 'Microsoft.Web/locations/managedApis'
    }
    testLinks: [
      {
        requestUri: '${environment().resourceManager}:443/subscriptions/c0a97786-cce2-4cf3-9f1a-022e775c19ad/resourceGroups/rg-fh-clc3-example/providers/Microsoft.Web/connections/${connections_cognitiveservicescomputervision_name}/extensions/proxy/vision/v2.0/models?api-version=2016-06-01'
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

output connections_cognitiveservicescomputervision_name_resource_id string = connections_cognitiveservicescomputervision_name_resource.id
output cognitiveService_name string = accounts_fhclc3excompvis_name_resource.name
