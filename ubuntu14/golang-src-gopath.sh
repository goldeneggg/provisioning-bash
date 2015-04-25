#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


# args
## 1 = dotfile path for go environments
declare ENV_RC=${1:-${PRVENV_DEFAULT_BASHRC}}
echo "go env dotfile path = ${ENV_RC}"

# set GOPATH
declare -r GOPATH=~/gopath
if [ ! -d ${GOPATH} ]
then
  mkdir -p ${GOPATH}
  echo "export GOPATH=${GOPATH}" >> ${ENV_RC}
  echo 'export PATH=${GOPATH}/bin:${GOROOT}/bin:$PATH' >> ${ENV_RC}
fi
