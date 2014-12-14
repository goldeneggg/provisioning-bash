#!/bin/bash

usage() {
    cat << __EOT__
Usage: $0

Install personal dotfiles
__EOT__
}

MYDIR=$(cd $(dirname $0) && pwd)
MYNAME=`basename $0`
WGETCMD="wget --no-check-certificate --no-cache"

# prepare dependency
#bash ${MYDIR}/cui.sh

# setup dotfiles
cd ~
git clone https://github.com/goldeneggg/dotfiles.git
cd dotfiles
bash setup.sh -L
