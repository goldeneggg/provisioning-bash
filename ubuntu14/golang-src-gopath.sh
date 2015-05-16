#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


echo "envfile path = ${ENV_RC}"

declare -r GOPATH=~/gopath
if [ ! -d ${GOPATH} ]
then
  mkdir -p ${GOPATH}
  echo "export GOPATH=${GOPATH}" >> ${ENV_RC}
  echo 'export PATH=${GOPATH}/bin:${GOROOT}/bin:$PATH' >> ${ENV_RC}
  set +u; source ${ENV_RC}; set -u
fi
