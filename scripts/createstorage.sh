STORAGE_ACCOUNT_NAME="stmoviesstate$(openssl rand -hex 3)"
echo "Storage Account Name: $STORAGE_ACCOUNT_NAME"

az storage account create \
  --resource-group rg-moviesterra-tfstate \
  --name $STORAGE_ACCOUNT_NAME \
  --sku Standard_LRS \
  --encryption-services blob \
  --location eastus

ACCOUNT_KEY=$(az storage account keys list \
  --resource-group rg-moviesterra-tfstate \
  --account-name $STORAGE_ACCOUNT_NAME \
  --query '[0].value' -o tsv)

az storage container create \
  --name tfstate \
  --account-name $STORAGE_ACCOUNT_NAME \
  --account-key "$ACCOUNT_KEY"

echo ""
echo "========================================="
echo "✅ Storage Account: $STORAGE_ACCOUNT_NAME"
echo "========================================="