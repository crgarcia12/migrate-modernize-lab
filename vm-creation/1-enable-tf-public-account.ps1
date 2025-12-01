# Enable storage account key access and allow public access
$storageAccountName = "crgarmigratetfstate"
$resourceGroupName = "crgar-migrate-tf-rg"

# Allow shared key access (key-based authentication)
az storage account update `
    --name $storageAccountName `
    --resource-group $resourceGroupName `
    --allow-shared-key-access true

# Enable public network access
az storage account update `
    --name $storageAccountName `
    --resource-group $resourceGroupName `
    --public-network-access Enabled

# Check current role assignments
az role assignment list `
    --assignee $(az account show --query user.name -o tsv) `
    --scope "/subscriptions/96c2852b-cf88-4a55-9ceb-d632d25b83a4/resourceGroups/crgar-migrate-tf-rg/providers/Microsoft.Storage/storageAccounts/crgarmigratetfstate"

# Assign Storage Blob Data Contributor role
az role assignment create `
    --assignee $(az account show --query user.name -o tsv) `
    --role "Storage Blob Data Contributor" `
    --scope "/subscriptions/96c2852b-cf88-4a55-9ceb-d632d25b83a4/resourceGroups/crgar-migrate-tf-rg/providers/Microsoft.Storage/storageAccounts/crgarmigratetfstate"

az storage account network-rule add `
    --resource-group "crgar-migrate-tf-rg" `
    --account-name "crgarmigratetfstate" `
    --ip-address "YOUR_PUBLIC_IP"
