#!/usr/bin/env bash

set -eu

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source functions.sh
source set-env.sh

  

# create resource group and AKS clsuter with OIDC and Workload Identity enabled

if [ $(azcli az group exists --name $RESOURCE_GROUP) == false ]; then
  echo "creating RG ${RESOURCE_GROUP}"
  azcli az group create --name ${RESOURCE_GROUP} --location ${LOCATION} -onone
else
  echo "RG ${RESOURCE_GROUP} already exists"
fi

if ! aks-cluster-exists ${RESOURCE_GROUP} ${AKS_NAME}; then

  echo "creating AKS ${AKS_NAME}"
  azcli az aks create -g ${RESOURCE_GROUP} -n ${AKS_NAME} \
    -onone \
    --node-count 1 \
    --enable-oidc-issuer \
    --generate-ssh-keys \
    --enable-workload-identity
else
  echo "AKS ${AKS_NAME} already exists"
fi

  
# connect to the AKS cluster
export KUBECONFIG=$BASEDIR/kubeconfig
azcli az aks get-credentials -n "${AKS_NAME}" -g "${RESOURCE_GROUP}"

