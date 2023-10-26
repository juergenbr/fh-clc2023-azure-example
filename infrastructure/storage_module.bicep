param location string
param functionContentShareName string
var storageAccounts_jbclc3examplestorage_name = 'storage${uniqueString(resourceGroup().id)}'

resource storageAccounts_jbclc3examplestorage_name_resource 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccounts_jbclc3examplestorage_name
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    dnsEndpointType: 'Standard'
    allowedCopyScope: 'AAD'
    defaultToOAuthAuthentication: false
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
}

resource functionContentShare 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-04-01' = {
  name: '${storageAccounts_jbclc3examplestorage_name_resource.name}/default/${functionContentShareName}'
}

output storageAccounts_jbclc3examplestorage_name_default_results_id string = storageAccounts_jbclc3examplestorage_name_default_results.id
output storageAccounts_jbclc3examplestorage_name_default_results_name string = storageAccounts_jbclc3examplestorage_name_default_results.name
output storageAccounts_jbclc3examplestorage_name_default_imageanalysis string = storageAccounts_jbclc3examplestorage_name_default_imageanalysis.name
output storageaccount_name string = storageAccounts_jbclc3examplestorage_name
