targetScope = 'resourceGroup'

param connections_ascalert_name string = 'ascalert'
param connections_azureblob_name string = 'azureblob'
param location string = 'westeurope'

var contentshare_name = 'functioncontentshare'

module insights_module 'insights_module.bicep' = {
  name: 'insights_module'
  params: {
    location: location
  }
}

module storage_module 'storage_module.bicep' = {
  name: 'storage_module'
  params: {
    location: location
    functionContentShareName: contentshare_name
  }
}

module congitiveservice_module 'cognitiveservice_module.bicep' = {
  name: 'cognitiveservice_module'
  params: {
    location: location
  }
}

module logicapp_module 'logicapp_module.bicep' = {
  name: 'logicapp_module'
  params: {
    location: location
    connections_azureblob_name_resource_id: storage_module.outputs.storageAccounts_jbclc3examplestorage_name_default_results
    connections_cognitiveservicescomputervision_name_resource_id: congitiveservice_module.outputs.connections_cognitiveservicescomputervision_name_resource_id
  }
}

module function_module 'function_module.bicep' = {
  name: 'function_module'
  params: {
    location: location
    storageaccount_name: storage_module.outputs.storageaccount_name
    container_name: storage_module.outputs.storageAccounts_jbclc3examplestorage_name_default_imageanalysis
    appInsights_name: insights_module.outputs.appInsights_name
    contentshare_name: contentshare_name
  }
}

resource connections_ascalert_name_resource 'Microsoft.Web/connections@2016-06-01' = {
  name: connections_ascalert_name
  location: location
  properties: {
    displayName: 'Microsoft Defender for Cloud Alert'
    statuses: [
      {
        status: 'Connected'
      }
    ]
    customParameterValues: {
    }
    nonSecretParameterValues: {
    }
    createdTime: '2022-08-14T12:16:34.7484763Z'
    changedTime: '2022-08-14T12:16:34.7484763Z'
    api: {
      name: connections_ascalert_name
      displayName: 'Microsoft Defender für Cloud-Warnung'
      description: 'Microsoft Defender für Cloud ist ein einheitliches System zur Verwaltung der Infrastruktursicherheit, das die Sicherheit Ihrer Rechenzentren stärkt und einen erweiterten Schutz gegen Bedrohungen für Ihre hybriden Workloads in der Cloud (in Azure oder bei anderen Anbietern) und lokal bietet.'
      iconUri: 'https://connectoricons-prod.azureedge.net/releases/v1.0.1592/1.0.1592.2970/${connections_ascalert_name}/icon.png'
      brandColor: '#0072C6'
      id: '/subscriptions/c0a97786-cce2-4cf3-9f1a-022e775c19ad/providers/Microsoft.Web/locations/westeurope/managedApis/${connections_ascalert_name}'
      type: 'Microsoft.Web/locations/managedApis'
    }
    testLinks: []
  }
}

resource connections_azureblob_name_resource 'Microsoft.Web/connections@2016-06-01' = {
  name: connections_azureblob_name
  location: location
  properties: {
    displayName: 'fh-clc3-example-connection'
    statuses: [
      {
        status: 'Ready'
      }
    ]
    customParameterValues: {
    }
    createdTime: '2022-08-15T17:16:09.904102Z'
    changedTime: '2022-08-15T18:33:46.510657Z'
    api: {
      name: connections_azureblob_name
      displayName: 'Azure Blob Storage'
      description: 'Microsoft Azure Storage bietet einen massiv skalierbaren, robusten und hoch verfügbaren Speicher für Daten in der Cloud und dient als Datenspeicherlösung für moderne Anwendungen. Stellen Sie eine Verbindung mit Blob Storage her, um für Blobs in Ihrem Azure Storage-Konto verschiedene Vorgänge durchzuführen wie beispielsweise Erstellen, Aktualisieren, Abrufen und Löschen.'
      iconUri: 'https://connectoricons-prod.azureedge.net/releases/v1.0.1591/1.0.1591.2961/${connections_azureblob_name}/icon.png'
      brandColor: '#804998'
      id: '/subscriptions/c0a97786-cce2-4cf3-9f1a-022e775c19ad/providers/Microsoft.Web/locations/westeurope/managedApis/${connections_azureblob_name}'
      type: 'Microsoft.Web/locations/managedApis'
    }
    testLinks: [
      {
        requestUri: '${environment().resourceManager}:443/subscriptions/c0a97786-cce2-4cf3-9f1a-022e775c19ad/resourceGroups/rg-fh-clc3-example/providers/Microsoft.Web/connections/${connections_azureblob_name}/extensions/proxy/testconnection?api-version=2016-06-01'
        method: 'get'
      }
    ]
  }
}





