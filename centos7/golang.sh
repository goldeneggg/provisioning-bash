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
GO_VERSION=1.3.3
${WGETCMD} https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz
tar -C /usr/local -zxf go${GO_VERSION}.linux-amd64.tar.gz
rm go${GO_VERSION}.linux-amd64.tar.gz
echo "export GOROOT=/usr/local/go" >> /etc/bashrc
echo "export PATH=/usr/local/go/bin:$PATH" >> /etc/bashrc
