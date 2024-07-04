
export LOCATION="westcentralus"
export RESOURCE_GROUP="aks-wi-oidc"

# environment variables for the Azure Key Vault resource
export AKS_NAME="aks-cluster"
export KEYVAULT_NAME="azwi-g1-kv-demo-003"
export KEYVAULT_SECRET_NAME="my-secret"

# environment variables for the Kubernetes Service account & federated identity credential
export SERVICE_ACCOUNT_NAMESPACE="default"
export SERVICE_ACCOUNT_NAME="workload-identity-sa"

# user assigned identity name
export UAID="fic-test-ua"

# federated identity name
export FICID="fic-test-fic-name"
