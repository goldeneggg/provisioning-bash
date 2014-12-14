#!/bin/bash

usage() {
    cat << __EOT__
Usage: $0

Install golang
__EOT__
}

MYDIR=$(cd $(dirname $0) && pwd)
MYNAME=`basename $0`
WGETCMD="wget --no-check-certificate --no-cache"

# prepare dependency
bash ${MYDIR}/init_ja.sh

# install golang
GO_VERSION=1.4
GO_PREFIX=/usr/local
GOROOT=${GO_PREFIX}/go
if [ -d ${GOROOT} ]
then
  rm -fr ${GOROOT}
fi

${WGETCMD} https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz
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
