#!/usr/bin/env bash

set -eu

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source functions.sh
source set-env.sh

  

USER_ASSIGNED_CLIENT_ID=$( get-identity-id-from-identity-name $RESOURCE_GROUP $UAID )

if ! keyvault-exists $RESOURCE_GROUP $KEYVAULT_NAME; then

  echo "creating keyvault and secret"
  azcli az keyvault create -onone \
    --name ${KEYVAULT_NAME} \
    --resource-group ${RESOURCE_GROUP} \
    --location ${LOCATION} \
    --enable-rbac-authorization=false
  azcli az keyvault secret set --vault-name ${KEYVAULT_NAME} --name ${KEYVAULT_SECRET_NAME} --value 'Hello!'
  
  echo "granting MI vault secret read permission"
  azcli az keyvault set-policy --name ${KEYVAULT_NAME} --secret-permissions get --spn ${USER_ASSIGNED_CLIENT_ID}
  
else
  echo keyvault already exists
fi
