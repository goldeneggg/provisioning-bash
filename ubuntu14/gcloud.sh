#!/bin/bash

# See: https://kubernetes.io/docs/tasks/tools/install-kubeadm/

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

: "----- add kubernetes officlal GPG KEY"
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

: "----- add repository"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

: "----- install google-cloud-sdk"
${PRVENV_CMD_PKG_UPD}
${PRVENV_CMD_PKG_INS} google-cloud-sdk

echo "Success install google-cloud-sdk. Please start by 'gcloud init'"
