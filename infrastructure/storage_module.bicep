param location string
var storageAccounts_jbclc3examplestorage_name = 'jbclc3examplestorage'

resource storageAccounts_jbclc3examplestorage_name_resource 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccounts_jbclc3examplestorage_name
  location: location
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    dnsEndpointType: 'Standard'
    allowedCopyScope: 'AAD'
    defaultToOAuthAuthentication: true
    publicNetworkAccess: 'Enabled'
    allowCrossTenantReplication: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      requireInfrastructureEncryption: true
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource storageAccounts_jbclc3examplestorage_name_default 'Microsoft.Storage/storageAccounts/blobServices@2021-09-01' = {
  parent: storageAccounts_jbclc3examplestorage_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    changeFeed: {
      enabled: false
    }
    restorePolicy: {
      enabled: false
    }
    containerDeleteRetentionPolicy: {
      enabled: false
    }
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: false
    }
    isVersioningEnabled: false
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_jbclc3examplestorage_name_default 'Microsoft.Storage/storageAccounts/fileServices@2021-09-01' = {
  parent: storageAccounts_jbclc3examplestorage_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {
      }
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: false
      days: 0
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_jbclc3examplestorage_name_default 'Microsoft.Storage/storageAccounts/queueServices@2021-09-01' = {
  parent: storageAccounts_jbclc3examplestorage_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_jbclc3examplestorage_name_default 'Microsoft.Storage/storageAccounts/tableServices@2021-09-01' = {
  parent: storageAccounts_jbclc3examplestorage_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource storageAccounts_jbclc3examplestorage_name_default_azure_webjobs_hosts 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' = {
  parent: storageAccounts_jbclc3examplestorage_name_default
  name: 'azure-webjobs-hosts'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [

    storageAccounts_jbclc3examplestorage_name_resource
  ]
}

resource storageAccounts_jbclc3examplestorage_name_default_azure_webjobs_secrets 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' = {
  parent: storageAccounts_jbclc3examplestorage_name_default
  name: 'azure-webjobs-secrets'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [

    storageAccounts_jbclc3examplestorage_name_resource
  ]
}

resource storageAccounts_jbclc3examplestorage_name_default_function_releases 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' = {
  parent: storageAccounts_jbclc3examplestorage_name_default
  name: 'function-releases'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [

    storageAccounts_jbclc3examplestorage_name_resource
  ]
}

resource storageAccounts_jbclc3examplestorage_name_default_imageanalysis 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' = {
  parent: storageAccounts_jbclc3examplestorage_name_default
  name: 'imageanalysis'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [

    storageAccounts_jbclc3examplestorage_name_resource
  ]
}

resource storageAccounts_jbclc3examplestorage_name_default_results 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' = {
  parent: storageAccounts_jbclc3examplestorage_name_default
  name: 'results'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [

    storageAccounts_jbclc3examplestorage_name_resource
  ]
}

resource Microsoft_Storage_storageAccounts_tableServices_tables_storageAccounts_jbclc3examplestorage_name_default_imageanalysis 'Microsoft.Storage/storageAccounts/tableServices/tables@2021-09-01' = {
  parent: Microsoft_Storage_storageAccounts_tableServices_storageAccounts_jbclc3examplestorage_name_default
  name: 'imageanalysis'
  properties: {
  }
  dependsOn: [

    storageAccounts_jbclc3examplestorage_name_resource
  ]
}

output storageAccounts_jbclc3examplestorage_name_default_results string = storageAccounts_jbclc3examplestorage_name_default_results.id
