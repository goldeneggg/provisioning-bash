#!/bin/bash

usage() {
    cat << __EOT__
Usage: $0

Install dependencies for mysql 5.6 community server
__EOT__
}

MYDIR=$(cd $(dirname $0) && pwd)
MYNAME=`basename $0`
WGETCMD="wget --no-check-certificate --no-cache"

# install dependencies
apt-get -y install build-essential cmake bison libncurses5-dev
