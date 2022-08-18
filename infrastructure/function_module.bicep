param location string
var sites_fh_clc3_example_name = 'fh-clc3-example'
var serverfarms_ASP_rgfhclc3example_b5db_name = 'ASP-rgfhclc3example-b5db'

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
  tags: {
    'hidden-link: /app-insights-resource-id': '/subscriptions/c0a97786-cce2-4cf3-9f1a-022e775c19ad/resourceGroups/rg-fh-clc3-example/providers/microsoft.insights/components/fh-clc3-example'
    'hidden-link: /app-insights-instrumentation-key': '4f49708e-7854-4491-92f1-317950e3d193'
    'hidden-link: /app-insights-conn-string': 'InstrumentationKey=4f49708e-7854-4491-92f1-317950e3d193;IngestionEndpoint=https://westeurope-5.in.applicationinsights.azure.com/;LiveEndpoint=https://westeurope.livediagnostics.monitor.azure.com/'
  }
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

resource sites_fh_clc3_example_name_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-03-01' = {
  parent: sites_fh_clc3_example_name_resource
  name: 'ftp'
  location: location
  tags: {
    'hidden-link: /app-insights-resource-id': '/subscriptions/c0a97786-cce2-4cf3-9f1a-022e775c19ad/resourceGroups/rg-fh-clc3-example/providers/microsoft.insights/components/fh-clc3-example'
    'hidden-link: /app-insights-instrumentation-key': '4f49708e-7854-4491-92f1-317950e3d193'
    'hidden-link: /app-insights-conn-string': 'InstrumentationKey=4f49708e-7854-4491-92f1-317950e3d193;IngestionEndpoint=https://westeurope-5.in.applicationinsights.azure.com/;LiveEndpoint=https://westeurope.livediagnostics.monitor.azure.com/'
  }
  properties: {
    allow: true
  }
}

resource sites_fh_clc3_example_name_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-03-01' = {
  parent: sites_fh_clc3_example_name_resource
  name: 'scm'
  location: location
  tags: {
    'hidden-link: /app-insights-resource-id': '/subscriptions/c0a97786-cce2-4cf3-9f1a-022e775c19ad/resourceGroups/rg-fh-clc3-example/providers/microsoft.insights/components/fh-clc3-example'
    'hidden-link: /app-insights-instrumentation-key': '4f49708e-7854-4491-92f1-317950e3d193'
    'hidden-link: /app-insights-conn-string': 'InstrumentationKey=4f49708e-7854-4491-92f1-317950e3d193;IngestionEndpoint=https://westeurope-5.in.applicationinsights.azure.com/;LiveEndpoint=https://westeurope.livediagnostics.monitor.azure.com/'
  }
  properties: {
    allow: true
  }
}

resource sites_fh_clc3_example_name_web 'Microsoft.Web/sites/config@2022-03-01' = {
  parent: sites_fh_clc3_example_name_resource
  name: 'web'
  location: location
  tags: {
    'hidden-link: /app-insights-resource-id': '/subscriptions/c0a97786-cce2-4cf3-9f1a-022e775c19ad/resourceGroups/rg-fh-clc3-example/providers/microsoft.insights/components/fh-clc3-example'
    'hidden-link: /app-insights-instrumentation-key': '4f49708e-7854-4491-92f1-317950e3d193'
    'hidden-link: /app-insights-conn-string': 'InstrumentationKey=4f49708e-7854-4491-92f1-317950e3d193;IngestionEndpoint=https://westeurope-5.in.applicationinsights.azure.com/;LiveEndpoint=https://westeurope.livediagnostics.monitor.azure.com/'
  }
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
    scmType: 'None'
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
    ipSecurityRestrictions: [
      {
        ipAddress: '212.241.69.10/32'
        action: 'Allow'
        tag: 'Default'
        priority: 100
        name: 'Home'
        description: 'Liwest Public IP'
      }
      {
        ipAddress: 'Any'
        action: 'Deny'
        priority: 2147483647
        name: 'Deny all'
        description: 'Deny all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 1
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: true
    http20Enabled: false
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'FtpsOnly'
    preWarmedInstanceCount: 0
    functionAppScaleLimit: 200
    functionsRuntimeScaleMonitoringEnabled: false
    minimumElasticInstanceCount: 0
    azureStorageAccounts: {
    }
  }
}

resource sites_fh_clc3_example_name_blobStorageUpload 'Microsoft.Web/sites/functions@2022-03-01' = {
  parent: sites_fh_clc3_example_name_resource
  name: 'blobStorageUpload'
  location: location
  properties: {
    script_root_path_href: 'https://fh-clc3-example.azurewebsites.net/admin/vfs/home/site/wwwroot/blobStorageUpload/'
    script_href: 'https://fh-clc3-example.azurewebsites.net/admin/vfs/home/site/wwwroot/clc3-azure-example-1.0-SNAPSHOT.jar'
    config_href: 'https://fh-clc3-example.azurewebsites.net/admin/vfs/home/site/wwwroot/blobStorageUpload/function.json'
    test_data_href: 'https://fh-clc3-example.azurewebsites.net/admin/vfs/tmp/FunctionsData/blobStorageUpload.dat'
    href: 'https://fh-clc3-example.azurewebsites.net/admin/functions/blobStorageUpload'
    config: {
    }
    invoke_url_template: 'https://fh-clc3-example.azurewebsites.net/api/blobstorageupload'
    language: 'java'
    isDisabled: false
  }
}

resource sites_fh_clc3_example_name_sites_fh_clc3_example_name_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2022-03-01' = {
  parent: sites_fh_clc3_example_name_resource
  name: '${sites_fh_clc3_example_name}.azurewebsites.net'
  location: location
  properties: {
    siteName: 'fh-clc3-example'
    hostNameType: 'Verified'
  }
}
