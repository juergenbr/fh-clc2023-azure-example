param cosmosdb_name string
param logicapp_identity_principalid string
param roleAssignmentGuid1 string = newGuid()
param roleAssignmentGuid2 string = newGuid()

resource cosmosdb 'Microsoft.DocumentDB/databaseAccounts@2022-05-15' existing = {
  name: cosmosdb_name
}

resource roleAssignment_cosmosdb 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: roleAssignmentGuid1
  scope: cosmosdb
  properties: {
    principalId: logicapp_identity_principalid
    roleDefinitionId: '/providers/Microsoft.Authorization/roleDefinitions/ba92f5b4-2d11-453d-a403-e96b0029c9fe'
    principalType: 'ServicePrincipal'
  }
}

resource roleAssignment_cosmosdbaccountreader 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: roleAssignmentGuid2
  scope: cosmosdb
  properties: {
    principalId: logicapp_identity_principalid
    roleDefinitionId: '/providers/Microsoft.Authorization/roleDefinitions/fbdf93bf-df7d-467e-a4d2-9458aa1360c8'
    principalType: 'ServicePrincipal'
  }
}

resource roleassignment 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2022-08-15' = {
  name: guid(cosmosdb.id)
  parent: cosmosdb
  properties: {
    principalId: logicapp_identity_principalid
    roleDefinitionId: '${cosmosdb.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002'
    scope: cosmosdb.id
  }
}
