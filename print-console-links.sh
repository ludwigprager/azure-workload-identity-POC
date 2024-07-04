#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ./functions.sh
source ./set-env.sh

SUBSCRIPTION_ID=$( get-subscription-id )
TENANT=$( azcli az account show | jq -r .tenantDisplayName )

ACCOUNT_ID=$( azcli az account show | jq -r .id )


echo
echo "resource group::        https://portal.azure.com/#@${TENANT}/resource/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${RESOURCE_GROUP}/overview"
echo "managed identitiy:      https://portal.azure.com/#browse/Microsoft.ManagedIdentity%2FuserAssignedIdentities"
echo "key vault:              https://portal.azure.com/#browse/Microsoft.KeyVault%2Fvaults"
echo "k8s cluster:            https://portal.azure.com/#browse/Microsoft.ContainerService%2FmanagedClusters"
echo "federated credentials:  https://portal.azure.com/#@${TENANT}/resource/subscriptions/${ACCOUNT_ID}/resourceGroups/${RESOURCE_GROUP}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${UAID}/federatedcredentials"
