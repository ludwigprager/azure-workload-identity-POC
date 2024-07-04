#!/usr/bin/env bash


get-account-key() {
  local ACCOUNT_KEY=$(az storage account keys list \
    --resource-group $RESOURCE_GROUP_NAME \
    --account-name $STORAGE_ACCOUNT_NAME \
    --query '[0].value' -o tsv)

  if [[ ! -z ${ACCOUNT_KEY} ]]; then
    printf ${ACCOUNT_KEY}
  fi
}
export -f get-account-key

install-kubectl() {
  # install kubectl
  if [[ ! -f ./kubectl ]]; then
    #KUBECTL_VERSION=${1:-1.30.2}
    KUBECTL_VERSION=1.30.2
    echo downloading kubectl $KUBECTL_VERSION
    curl -LO https://dl.k8s.io/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl
    chmod +x kubectl
fi

}


get-subscription-id() {
  local subscription_id=$(az account list -o json | jq -r .[].id)

  if [[ ! -z ${subscription_id} ]]; then
    printf ${subscription_id}
  fi
}
export -f get-subscription-id

azcli() {
# local C_TOOL=docker
  local C_TOOL=podman
  local IMAGE=mcr.microsoft.com/azure-cli:2.61.0

  if [ $# -eq 0 ]; then
    COMMAND="/bin/bash"
  else
    COMMAND=$*
  fi

  ${C_TOOL} run \
    --rm \
    -w /work/ \
    -v $(pwd):/work/ \
    -v ${HOME}/.azure/:/.azure/ \
    -e AZURE_CONFIG_DIR='/.azure/' \
    -e KUBECONFIG=/work/kubeconfig \
    ${IMAGE} \
    ${COMMAND}
}
export -f azcli


get-identity-id-from-identity-name() {
  local resource_group=$1
  local identity_name=$2

  id=$(azcli az identity show \
    --resource-group ${resource_group} \
    --name ${identity_name} \
    --query 'clientId' -otsv)

  printf $id
}
export -f get-identity-id-from-identity-name

aks-cluster-exists() {
  local resource_group=$1
  local cluster_name=$2

  if azcli  az aks show --name $cluster_name -g $resource_group > /dev/null 2>&1 ; then
    # 0 = true
    return 0 
  else
    # 1 = false
    return 1
  fi
}
export -f aks-cluster-exists

identity-exists() {
  local resource_group=$1
  local identity_name=$2

  if azcli  az identity  show --name $identity_name -g $resource_group > /dev/null; then
    return 0 
  fi
  return 1
}
export -f identity-exists

federated-identity-exists() {
  local resource_group=$1
  local name=$2
  local identity_name=$3

  if azcli  az identity  federated-credential show \
       --name $name \
       --identity-name $identity_name \
       -g $resource_group \
       > /dev/null 2>&1 ; then
    return 0 
  fi
  return 1
}
export -f federated-identity-exists

keyvault-exists() {
  local resource_group=$1
  local keyvault_name=$2

  if azcli az keyvault show --name $keyvault_name -g $resource_group > /dev/null; then
    return 0 
  fi
  return 1
}
export -f keyvault-exists


