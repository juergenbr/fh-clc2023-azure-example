param workflows_fh_clc3_logicapp_name string = 'fh-clc3-logicapp'
param connections_azureblob_1_externalid string = '/subscriptions/c0a97786-cce2-4cf3-9f1a-022e775c19ad/resourceGroups/rg-fh-clc3-example/providers/Microsoft.Web/connections/azureblob-1'
param connections_cognitiveservicescomputervision_externalid string = '/subscriptions/c0a97786-cce2-4cf3-9f1a-022e775c19ad/resourceGroups/rg-fh-clc3-example/providers/Microsoft.Web/connections/cognitiveservicescomputervision'
param connections_documentdb_externalid string = '/subscriptions/c0a97786-cce2-4cf3-9f1a-022e775c19ad/resourceGroups/rg-fh-clc3-example/providers/Microsoft.Web/connections/documentdb'

resource workflows_fh_clc3_logicapp_name_resource 'Microsoft.Logic/workflows@2017-07-01' = {
  name: workflows_fh_clc3_logicapp_name
  location: 'westeurope'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {
        '$connections': {
          defaultValue: {
          }
          type: 'Object'
        }
      }
      triggers: {
        'When_a_blob_is_added_or_modified_(properties_only)_(V2)': {
          recurrence: {
            frequency: 'Minute'
            interval: 1
          }
          evaluatedRecurrence: {
            frequency: 'Minute'
            interval: 1
          }
          splitOn: '@triggerBody()'
          metadata: {
            'JTJmaW1hZ2VhbmFseXNpcw==': '/imageanalysis'
            'JTJmdGVzdGNvbnRhaW5lcg==': '/testcontainer'
          }
          type: 'ApiConnection'
          inputs: {
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'azureblob_1\'][\'connectionId\']'
              }
            }
            method: 'get'
            path: '/v2/datasets/@{encodeURIComponent(encodeURIComponent(\'storage4xn73xp6xleaa\'))}/triggers/batch/onupdatedfile'
            queries: {
              checkBothCreatedAndModifiedDateTime: false
              folderId: 'JTJmaW1hZ2VhbmFseXNpcw=='
              maxFileCount: 1
            }
          }
        }
      }
      actions: {
        Compose: {
          runAfter: {
            Initialize_variable: [
              'Succeeded'
            ]
          }
          type: 'Compose'
          inputs: '@variables(\'entity_object\')'
        }
        'Create_blob_(V2)': {
          runAfter: {
            'Create_or_update_document_(V3)': [
              'Succeeded'
            ]
          }
          type: 'ApiConnection'
          inputs: {
            body: '@body(\'Parse_JSON\')'
            headers: {
              ReadFileMetadataFromServer: true
            }
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'azureblob_1\'][\'connectionId\']'
              }
            }
            method: 'post'
            path: '/v2/datasets/@{encodeURIComponent(encodeURIComponent(\'storage4xn73xp6xleaa\'))}/files'
            queries: {
              folderPath: '/results'
              name: '@{body(\'Parse_JSON\')?[\'filename\']}.json'
              queryParametersSingleEncoded: true
            }
          }
          runtimeConfiguration: {
            contentTransfer: {
              transferMode: 'Chunked'
            }
          }
        }
        'Create_or_update_document_(V3)': {
          runAfter: {
            Parse_JSON: [
              'Succeeded'
            ]
          }
          type: 'ApiConnection'
          inputs: {
            body: '@body(\'Parse_JSON\')'
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'documentdb\'][\'connectionId\']'
              }
            }
            method: 'post'
            path: '/v2/cosmosdb/@{encodeURIComponent(\'fh-clc3-cosmosdb\')}/dbs/@{encodeURIComponent(\'ImageAnalysis\')}/colls/@{encodeURIComponent(\'results\')}/docs'
          }
        }
        'Get_blob_content_using_path_(V2)': {
          runAfter: {
          }
          type: 'ApiConnection'
          inputs: {
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'azureblob_1\'][\'connectionId\']'
              }
            }
            method: 'get'
            path: '/v2/datasets/@{encodeURIComponent(encodeURIComponent(\'storage4xn73xp6xleaa\'))}/GetFileContentByPath'
            queries: {
              inferContentType: true
              path: '@triggerBody()?[\'Path\']'
              queryParametersSingleEncoded: true
            }
          }
        }
        Initialize_variable: {
          runAfter: {
            'Tag_Image_(V3)': [
              'Succeeded'
            ]
          }
          type: 'InitializeVariable'
          inputs: {
            variables: [
              {
                name: 'entity_object'
                type: 'string'
                value: '{\n"id":"@{triggerBody()?[\'Id\']}",\n"filename":"@{triggerBody()?[\'Name\']}",\n"mediatype": "@{triggerBody()?[\'MediaType\']}",\n"path":"@{triggerBody()?[\'Path\']}",\n"size":"@{triggerBody()?[\'Size\']}",\n"tags":@{body(\'Tag_Image_(V3)\')?[\'tags\']}\n}'
              }
            ]
          }
        }
        Parse_JSON: {
          runAfter: {
            Compose: [
              'Succeeded'
            ]
          }
          type: 'ParseJson'
          inputs: {
            content: '@outputs(\'Compose\')'
            schema: {
              properties: {
                filename: {
                  type: 'string'
                }
                id: {
                  type: 'string'
                }
                mediatype: {
                  type: 'string'
                }
                path: {
                  type: 'string'
                }
                size: {
                  type: 'string'
                }
                tags: {
                  items: {
                    properties: {
                      confidence: {
                        type: 'number'
                      }
                      hint: {
                        type: 'string'
                      }
                      name: {
                        type: 'string'
                      }
                    }
                    required: [
                      'name'
                      'confidence'
                    ]
                    type: 'object'
                  }
                  type: 'array'
                }
              }
              type: 'object'
            }
          }
        }
        'Tag_Image_(V3)': {
          runAfter: {
            'Get_blob_content_using_path_(V2)': [
              'Succeeded'
            ]
          }
          type: 'ApiConnection'
          inputs: {
            body: '@body(\'Get_blob_content_using_path_(V2)\')'
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'cognitiveservicescomputervision\'][\'connectionId\']'
              }
            }
            method: 'post'
            path: '/v3/subdomain/@{encodeURIComponent(encodeURIComponent(\'autoFilledSubdomain\'))}/vision/v2.0/tag'
            queries: {
              format: 'Image Content'
            }
          }
        }
      }
      outputs: {
      }
    }
    parameters: {
      '$connections': {
        value: {
          azureblob_1: {
            connectionId: connections_azureblob_1_externalid
            connectionName: 'azureblob-1'
            connectionProperties: {
              authentication: {
                type: 'ManagedServiceIdentity'
              }
            }
            id: '/subscriptions/c0a97786-cce2-4cf3-9f1a-022e775c19ad/providers/Microsoft.Web/locations/westeurope/managedApis/azureblob'
          }
          cognitiveservicescomputervision: {
            connectionId: connections_cognitiveservicescomputervision_externalid
            connectionName: 'cognitiveservicescomputervision'
            id: '/subscriptions/c0a97786-cce2-4cf3-9f1a-022e775c19ad/providers/Microsoft.Web/locations/westeurope/managedApis/cognitiveservicescomputervision'
          }
          documentdb: {
            connectionId: connections_documentdb_externalid
            connectionName: 'documentdb'
            connectionProperties: {
              authentication: {
                type: 'ManagedServiceIdentity'
              }
            }
            id: '/subscriptions/c0a97786-cce2-4cf3-9f1a-022e775c19ad/providers/Microsoft.Web/locations/westeurope/managedApis/documentdb'
          }
        }
      }
    }
  }
}