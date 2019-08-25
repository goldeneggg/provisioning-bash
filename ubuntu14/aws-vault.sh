#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

# args
declare -r AWS_VAULT_VERSION=${1:-"4.2.0"}

: "----- install dependency packages"
${PRVENV_CMD_PKG_INS} curl

# See: https://docs.cloudposse.com/tools/aws-vault/
: "----- install aws-vault of specific version"
declare -r PREFIX=/usr/local
curl -L -o ${PREFIX}/bin/aws-vault https://github.com/99designs/aws-vault/releases/download/v${AWS_VAULT_VERSION}/aws-vault-linux-amd64
chmod 755 ${PREFIX}/bin/aws-vault

echo "Installation aws-vault was succeed. Please confirm setup manual https://docs.cloudposse.com/tools/aws-vault/"
