#!/bin/bash

#>>>>>>>>>> prepare
MYNAME=`basename $0`
MYDIR=$(cd $(dirname $0) && pwd)
MYUSER=$(whoami)

# load environments
source ${MYDIR}/envs
#<<<<<<<<<<


# args
## 1 = dotfile path for go environments
ENV_RC=${PRVENV_DEFAULT_BASHRC}
if [ $# -eq 1 ]
then
  ENV_RC=${1}
  echo "ARGS(1) = go env dotfile path = ${ENV_RC}"
fi

# set GOPATH
GOPATH=~/gopath
if [ ! -d ${GOPATH} ]
then
  mkdir -p ${GOPATH}
  echo "export GOPATH=${GOPATH}" >> ${ENV_RC}
  echo 'export PATH=${GOPATH}/bin:${GOROOT}/bin:$PATH' >> ${ENV_RC}
fi
