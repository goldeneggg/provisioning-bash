#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


# args
## 1 = dotfile path for go environments
declare ENV_RC=${PRVENV_DEFAULT_BASHRC}
if [ ${MYUSER} != "root" ]
then
  ENV_RC=${PRVENV_USER_BASHRC}
fi
echo "envfile path = ${ENV_RC}"

declare -r GOPATH=~/gopath
if [ ! -d ${GOPATH} ]
then
  mkdir -p ${GOPATH}
  echo "export GOPATH=${GOPATH}" >> ${ENV_RC}
  echo 'export PATH=${GOPATH}/bin:${GOROOT}/bin:$PATH' >> ${ENV_RC}
fi
