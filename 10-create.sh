#!/usr/bin/env bash

set -eu

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source functions.sh
source set-env.sh


if [[ $# -eq 0 ]]; then
  echo $0 "<subscription name>"
  exit
fi

SUBSCRIPTION_NAME=$1

./20-create-rg-and-cluster.sh
./30-create-user-assigned-managed-identity.sh  $SUBSCRIPTION_NAME
./40-create-keyvault-and-secret.sh
./50-create-sa-and-federate.sh
./60-deploy-pod-with-sa.sh

