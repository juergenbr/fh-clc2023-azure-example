param location string
param storageaccount_name string
param imagecontainer_name string
param resultscontainer_name string
//param appInsights_name string
param contentshare_name string
param cogService_name string
param customVisionServicePrediction_name string
param customVisionServiceTraining_name string
var sites_fh_clc3_example_name = 'fh-clc3-${uniqueString(resourceGroup().id)}'
var serverfarms_ASP_rgfhclc3example_b5db_name = 'ASP-rgfhclc3example-b5db'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  name: storageaccount_name
}

/*
resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: appInsights_name
}
*/

resource cogService 'Microsoft.CognitiveServices/accounts@2022-03-01' existing = {
  name: cogService_name
}

resource customVisionService 'Microsoft.CognitiveServices/accounts@2022-03-01' existing = {
  name: customVisionServicePrediction_name
}

resource customVisionServiceTraining 'Microsoft.CognitiveServices/accounts@2022-03-01' existing = {
  name: customVisionServiceTraining_name
}

resource serverfarms_ASP_rgfhclc3example_b5db_name_resource 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: serverfarms_ASP_rgfhclc3example_b5db_name
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
    size: 'Y1'
    family: 'Y'
    capacity: 0
  }
  kind: 'functionapp'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: true
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

resource sites_fh_clc3_example_name_resource 'Microsoft.Web/sites@2022-03-01' = {
  name: sites_fh_clc3_example_name
  location: location
  kind: 'functionapp,linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${sites_fh_clc3_example_name}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${sites_fh_clc3_example_name}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: serverfarms_ASP_rgfhclc3example_b5db_name_resource.id
    reserved: true
    isXenon: false
    hyperV: false
    vnetRouteAllEnabled: false
    siteConfig: {
      numberOfWorkers: 1
      linuxFxVersion: 'JAVA|11'
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: false
      functionAppScaleLimit: 200
      minimumElasticInstanceCount: 0
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    customDomainVerificationId: '8FE71F284655B3A3973984D1DEF2C07A3EC59CECC8836CE2054DA20798A8F546'
    containerSize: 1536
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    redundancyMode: 'None'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}

resource sites_fh_clc3_example_name_web 'Microsoft.Web/sites/config@2022-03-01' = {
  parent: sites_fh_clc3_example_name_resource
  name: 'web'
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
    ]
    netFrameworkVersion: 'v4.0'
    linuxFxVersion: 'JAVA|11'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    remoteDebuggingVersion: 'VS2019'
    httpLoggingEnabled: false
    acrUseManagedIdentityCreds: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    publishingUsername: '$fh-clc3-example'
    scmType: 'GitHubAction'
    use32BitWorkerProcess: false
    webSocketsEnabled: false
    alwaysOn: false
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: false
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    vnetRouteAllEnabled: false
    vnetPrivatePortsCount: 0
    cors: {
      allowedOrigins: [
        'https://portal.azure.com'
      ]
      supportCredentials: false
    }
    localMySqlEnabled: false
    managedServiceIdentityId: 26997
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 1
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: false
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'FtpsOnly'
    preWarmedInstanceCount: 0
    functionAppScaleLimit: 200
    functionsRuntimeScaleMonitoringEnabled: false
    minimumElasticInstanceCount: 0
    azureStorageAccounts: {}
    appSettings: [
      {
        name: 'STORAGEACCOUNT_NAME'
        value: storageaccount_name
      }
      {
        name: 'CONTAINERNAME'
        value: imagecontainer_name
      }
      {
        name: 'RESULTSCONTAINERNAME'
        value: resultscontainer_name
      }
      /*{
        name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
        value: appInsights.properties.InstrumentationKey
      }*/
      {
        name: 'AzureWebJobsStorage'
        value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value}'
      }
      {
        name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
        value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value}'
      }
      {
        name: 'FUNCTIONS_EXTENSION_VERSION'
        value: '~4'
      }
      {
        name: 'FUNCTIONS_WORKER_RUNTIME'
        value: 'java'
      }
      {
        name: 'WEBSITE_CONTENTSHARE'
        value: contentshare_name
      }
      {
        name: 'SUBSCRIPTIONKEY'
        value: cogService.listKeys().key1
      }
      {
        name: 'CUSTOM_VISION_TRAINING_ENDPOINT'
        value: customVisionServiceTraining.properties.endpoint
      }
      {
        name: 'CUSTOM_VISION_TRAINING_KEY'
        value: customVisionServiceTraining.listKeys().key1
      }
      {
        name: 'CUSTOM_VISION_PREDICTION_ENDPOINT'
        value: customVisionService.properties.endpoint
      }
      {
        name: 'CUSTOM_VISION_PREDICTION_KEY'
        value: customVisionService.listKeys().key1
      }
    ]
  }
}

resource sites_fh_clc3_example_name_sites_fh_clc3_example_name_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2022-03-01' = {
  parent: sites_fh_clc3_example_name_resource
  name: '${sites_fh_clc3_example_name}.azurewebsites.net'
  properties: {
    siteName: 'fh-clc3-example'
    hostNameType: 'Verified'
  }
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(storageaccount_name, sites_fh_clc3_example_name_resource.id)
  scope: storageAccount
  properties: {
    principalId: sites_fh_clc3_example_name_resource.identity.principalId
    roleDefinitionId: '/providers/Microsoft.Authorization/roleDefinitions/ba92f5b4-2d11-453d-a403-e96b0029c9fe'
    principalType: 'ServicePrincipal'
  }
}
