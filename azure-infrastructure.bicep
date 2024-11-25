@description('The name of the Function App.')
param functionAppName string = 'intent-detector'

@description('The name of the existing App Service Plan.')
param appServicePlanName string = 'intent-system-00-service-plan'

@description('The Azure region where the Function App will be created.')
param location string = resourceGroup().location

@description('The User-Assigned Managed Identity Principal ID.')
param identityName string

@description('The Azure Storage Account connection string.')
@secure()
param storageConnectionString string

@description('The runtime stack for the Azure Function.')
param runtime string = 'dotnet'

// Function App Resource
resource functionApp 'Microsoft.Web/sites@2022-03-01' = {
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
