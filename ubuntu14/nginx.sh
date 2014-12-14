#!/bin/bash

usage() {
    cat << __EOT__
Usage: $0

Setup nginx environment
__EOT__
}

MYDIR=$(cd $(dirname $0) && pwd)
MYNAME=`basename $0`
WGETCMD="wget --no-check-certificate --no-cache"

# prepare dependency
bash ${MYDIR}/init_ja.sh

# install
apt-get -y install nginx

# start
service nginx start
