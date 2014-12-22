#!/bin/bash

#>>>>>>>>>> prepare
MYNAME=`basename $0`
MYDIR=$(cd $(dirname $0) && pwd)

# load environments
source ${MYDIR}/envs
#<<<<<<<<<<


# prepare dependency
bash ${MYDIR}/init_ja.sh

# args
## 1 = go version
GO_VERSION="1.4"
if [ $# -eq 1 ]
then
  GO_VERSION=${1}
  echo "ARGS(1) = go version = ${GO_VERSION}"
fi

# install golang
GO_PREFIX=/usr/local
GOROOT=${GO_PREFIX}/go
if [ -d ${GOROOT} ]
then
  rm -fr ${GOROOT}
fi

${PRVENV_WGETCMD} https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz
tar -C ${GO_PREFIX} -zxf go${GO_VERSION}.linux-amd64.tar.gz
rm go${GO_VERSION}.linux-amd64.tar.gz

# set environments
GOPATH=~/gopath
if [ ! -d ${GOPATH} ]
then
  mkdir -p ${GOPATH}
fi
echo "export GOROOT=${GOROOT}" >> /etc/bash.bashrc
echo "export GOPATH=${GOPATH}" >> /etc/bash.bashrc
echo 'export PATH=${GOPATH}/bin:${GOROOT}/bin:$PATH' >> /etc/bash.bashrc
