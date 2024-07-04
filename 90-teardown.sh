#!/usr/bin/env bash

set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/set-env.sh

set +e

echo deleting RG $RESOURCE_GROUP
azcli az group delete --name ${RESOURCE_GROUP} --yes

echo renaming kubeconfig
MY_RANDOM=$RANDOM
mv kubeconfig kubeconfig.${MY_RANDOM} 2> /dev/null
