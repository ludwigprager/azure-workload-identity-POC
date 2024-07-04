#!/usr/bin/env bash

set -eu

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source functions.sh
source set-env.sh


if [[ $# -eq 0 ]]; then
  echo
  echo usage: $0 "<subscription name>"
  exit
fi

SUBSCRIPTION_NAME=$1
SUBSCRIPTION=$( \
  azcli az account show --name $SUBSCRIPTION_NAME | jq -r .id \
)


if ! identity-exists $RESOURCE_GROUP $UAID; then

  echo creating user assigned managed identity $UAID
  azcli az identity create --name "${UAID}" \
    --resource-group "${RESOURCE_GROUP}" \
    --location "${LOCATION}" \
    --subscription "${SUBSCRIPTION}"
else
  echo identity $UAID already exists
fi
  
