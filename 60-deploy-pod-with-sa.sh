#!/usr/bin/env bash

set -eu

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source functions.sh
source set-env.sh

install-kubectl
export KUBECONFIG=$BASEDIR/kubeconfig

export KEYVAULT_URL="$(azcli az keyvault show -g ${RESOURCE_GROUP} -n ${KEYVAULT_NAME} --query properties.vaultUri -o tsv)"
cat <<EOF | ./kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: quick-start
  namespace: ${SERVICE_ACCOUNT_NAMESPACE}
  labels:
    azure.workload.identity/use: "true"
spec:
  serviceAccountName: ${SERVICE_ACCOUNT_NAME}
  containers:
#   - image: ghcr.io/azure/azure-workload-identity/msal-go:v1.3.0
    - image: ghcr.io/azure/azure-workload-identity/msal-go@sha256:e829c99afb8f78809faf4565cf3f624cf7f1e787f07ad37dafafbb6632f59630

      name: oidc
      env:
      - name: KEYVAULT_URL
        value: ${KEYVAULT_URL}
      - name: SECRET_NAME
        value: ${KEYVAULT_SECRET_NAME}
  nodeSelector:
    kubernetes.io/os: linux
EOF


./kubectl describe pod quick-start
./kubectl logs quick-start
# outputs: "successfully got secret" secret="Hello!"
  
