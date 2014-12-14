#!/bin/bash

usage() {
    cat << __EOT__
Usage: $0

Install initial packages and set config files
__EOT__
}

MYDIR=$(cd $(dirname $0) && pwd)
MYNAME=`basename $0`
WGETCMD="wget --no-check-certificate --no-cache"

# prepare dependency
bash ${MYDIR}/init_ja.sh

# install packages for cui environment
apt-get -y install ncurses-term screen tmux git subversion zsh vim stow ctags lv

# copy files

# from remote to local files
#REMOTE_TARGETS=(<REMOTE FILE>)
#LOCAL_DIR=/tmp/remotefile
#mkdir ${LOCAL_DIR}
#for rt in ${REMOTE_TARGETS[@]}
#do
#  ${WGETCMD} -O ${LOCAL_DIR}/`basename ${rt}` ${rt}
#done
