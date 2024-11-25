param project string = 'intent-system-00'
param appServicePlanName string = '${project}-service-plan'
param identityName string = '${project}-indentity'

param functionAppName string

param location string = resourceGroup().location

param runtime string = 'dotnet'
@secure()
param storageConnectionString string

resource functionApp 'Microsoft.Web/sites@2024-04-01' = {
  name: functionAppName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${identityName}': {}
    }
  }
  kind: 'functionapp'
  properties: {
    serverFarmId: resourceId('Microsoft.Web/serverfarms', appServicePlanName)
    siteConfig: {
      appSettings: [
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: runtime
        }
        {
          name: 'AzureWebJobsStorage'
          value: storageConnectionString
        }
      ]
    }
    httpsOnly: true
  }
}
