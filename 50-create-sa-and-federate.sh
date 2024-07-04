#!/usr/bin/env bash

set -eu

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source functions.sh
source set-env.sh


USER_ASSIGNED_CLIENT_ID=$( \
  get-identity-id-from-identity-name \
    $RESOURCE_GROUP \
    $UAID \
)
  
install-kubectl
export KUBECONFIG=$BASEDIR/kubeconfig

# create a Kubernetes service account and annotate it with the client ID of the Managed Identity
cat <<EOF | ./kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    azure.workload.identity/client-id: ${USER_ASSIGNED_CLIENT_ID}
  labels:
    azure.workload.identity/use: "true"
  name: ${SERVICE_ACCOUNT_NAME}
  namespace: ${SERVICE_ACCOUNT_NAMESPACE}
EOF


if federated-identity-exists $RESOURCE_GROUP $FICID $UAID; then
  echo federated identity credential already exists
else

  # get the OIDC Issuer URL
  AKS_OIDC_ISSUER="$(azcli az aks show -n ${AKS_NAME} -g ${RESOURCE_GROUP} --query "oidcIssuerProfile.issuerUrl" -otsv)"
  
  echo creating federated identity credential
  # Use the az identity federated-credential create command to create the federated identity credential 
  # between the managed identity, the service account issuer, and the subject.
  azcli az identity federated-credential create -onone \
    --name ${FICID} \
    --identity-name ${UAID} \
    --resource-group ${RESOURCE_GROUP} \
    --issuer ${AKS_OIDC_ISSUER} \
    --subject system:serviceaccount:${SERVICE_ACCOUNT_NAMESPACE}:${SERVICE_ACCOUNT_NAME}

  # wait few minutes for the federation to propagate...
fi
  
