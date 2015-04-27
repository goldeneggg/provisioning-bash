#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


[ $(isroot) ] || (echo "${MYUSER} can not run ${MYNAME}"; exit 1)

# args
## 1 = go version
declare GO_VERSION=${1:-"1.4.2"}
echo "go version = ${GO_VERSION}"

: "----- install golang"
declare -r GO_PREFIX=/usr/local
declare -r GOROOT=${GO_PREFIX}/go
[ -d ${GOROOT} ] && rm -fr ${GOROOT}

${PRVENV_WGETCMD} https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz
tar -C ${GO_PREFIX} -zxf go${GO_VERSION}.linux-amd64.tar.gz
rm go${GO_VERSION}.linux-amd64.tar.gz

: "----- set golang environments"
echo "export GOROOT=${GOROOT}" >> ${ENV_RC}
declare -r GOPATH=~/gopath
if [ ! -d ${GOPATH} ]
then
  mkdir -p ${GOPATH}
  echo "export GOPATH=${GOPATH}" >> ${ENV_RC}
  echo 'export PATH=${GOPATH}/bin:${GOROOT}/bin:$PATH' >> ${ENV_RC}
fi
source ${ENV_RC}
