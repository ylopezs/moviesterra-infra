#!/bin/bash

# Configuration variables
RESOURCE_GROUP_NAME="rg-moviesterra-tfstate"
STORAGE_ACCOUNT_NAME="stmoviesstate$(openssl rand -hex 3)"  # Generates unique name
CONTAINER_NAME="tfstate"
LOCATION="eastus"

echo "Creating Azure resources for MoviesTerra Terraform remote state..."
echo "========================================================"

# Step 1: Create Resource Group
echo "1. Creating Resource Group: $RESOURCE_GROUP_NAME"
az group create \
  --name $RESOURCE_GROUP_NAME \
  --location $LOCATION

# Step 2: Create Storage Account
echo "2. Creating Storage Account: $STORAGE_ACCOUNT_NAME"
az storage account create \
  --resource-group $RESOURCE_GROUP_NAME \
  --name $STORAGE_ACCOUNT_NAME \
  --sku Standard_LRS \
  --encryption-services blob \
  --location $LOCATION

# Step 3: Get Storage Account Key
echo "3. Getting Storage Account Key..."
ACCOUNT_KEY=$(az storage account keys list \
  --resource-group $RESOURCE_GROUP_NAME \
  --account-name $STORAGE_ACCOUNT_NAME \
  --query '[0].value' -o tsv)

# Step 4: Create Blob Container
echo "4. Creating Blob Container: $CONTAINER_NAME"
az storage container create \
  --name $CONTAINER_NAME \
  --account-name $STORAGE_ACCOUNT_NAME \
  --account-key $ACCOUNT_KEY

# Display the values you need
echo ""
echo "========================================================"
echo "✅ MoviesTerra Remote State - SUCCESS!"
echo "========================================================"
echo "resource_group_name  = \"$RESOURCE_GROUP_NAME\""
echo "storage_account_name = \"$STORAGE_ACCOUNT_NAME\""
echo "container_name       = \"$CONTAINER_NAME\""
echo "key                  = \"terraform.tfstate\""
echo "========================================================"
echo ""
echo "Copy the storage_account_name to your backend.tf file!"