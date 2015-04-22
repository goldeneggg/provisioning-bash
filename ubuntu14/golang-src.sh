#!/bin/bash

#>>>>>>>>>> prepare
set -eu

declare -r MYNAME=`basename $0`
declare -r MYDIR=$(cd $(dirname $0) && pwd)
declare -r MYUSER=$(whoami)

# load environments
source ${MYDIR}/envs
#<<<<<<<<<<


# root only
if [ ${MYUSER} != "root" ]
then
  echo "${MYUSER} can not run ${MYNAME}"
  exit 1
fi

# args
## 1 = go version
declare GO_VERSION="1.4"
if [ $# -eq 1 ]
then
  GO_VERSION=${1}
  echo "ARGS(1) = go version = ${GO_VERSION}"
fi

# install golang
declare -r GO_PREFIX=/usr/local
declare -r GOROOT=${GO_PREFIX}/go
if [ -d ${GOROOT} ]
then
  # if already installed, remove it and re-install
  rm -fr ${GOROOT}
fi

${PRVENV_WGETCMD} https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz
tar -C ${GO_PREFIX} -zxf go${GO_VERSION}.linux-amd64.tar.gz
rm go${GO_VERSION}.linux-amd64.tar.gz

# set common environments
echo "export GOROOT=${GOROOT}" >> ${PRVENV_DEFAULT_BASHRC}

# set environments
declare -r GOPATH=~/gopath
if [ ! -d ${GOPATH} ]
then
  mkdir -p ${GOPATH}
  echo "export GOPATH=${GOPATH}" >> ${PRVENV_DEFAULT_BASHRC}
  echo 'export PATH=${GOPATH}/bin:${GOROOT}/bin:$PATH' >> ${PRVENV_DEFAULT_BASHRC}
fi
