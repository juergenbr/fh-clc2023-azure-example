param cosmosdb_name string
param logicapp_identity_principalid string

resource cosmosdb 'Microsoft.DocumentDB/databaseAccounts@2022-05-15' existing = {
  name: cosmosdb_name
}

resource roleAssignment_cosmosdb 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(cosmosdb.id)
  scope: cosmosdb
  properties: {
    principalId: logicapp_identity_principalid
    roleDefinitionId: '/providers/Microsoft.Authorization/roleDefinitions/ba92f5b4-2d11-453d-a403-e96b0029c9fe'
    principalType: 'ServicePrincipal'
  }
}

resource roleassignment 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2021-10-15' = {
  name: guid(cosmosdb.id)
  parent: cosmosdb
  properties: {
    principalId: logicapp_identity_principalid
    roleDefinitionId: '${cosmosdb.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002'
    scope: cosmosdb.id
  }
}
