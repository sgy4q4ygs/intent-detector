#!/usr/bin/env sh

FUNCTION_APP_NAME=intent-detector
RESOURCE_GROUP=intent-system-00-rg
STORAGE_ACCOUNT=intentsystem00storage
APP_SERVICE_PLAN=intent-system-00-service-plan
IDENTITY_NAME=intent-system-00-identity

STORAGE_CONNECTION_STRING=$(az storage account show-connection-string \
    --name "$STORAGE_ACCOUNT" \
    --resource-group "$RESOURCE_GROUP" \
    --query connectionString \
    --output tsv)

az deployment group create \
    --name "$FUNCTION_APP_NAME-deployment" \
    --resource-group "$RESOURCE_GROUP" \
    --template-file azure-infrastructure.bicep \
    --parameters \
        functionAppName="$FUNCTION_APP_NAME" \
        appServicePlanName="$APP_SERVICE_PLAN" \
        identityName="$IDENTITY_NAME" \
        storageConnectionString="$STORAGE_CONNECTION_STRING"
