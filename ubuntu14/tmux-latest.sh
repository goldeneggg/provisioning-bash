#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

# args
declare -r TMUX_VERSION=${1:-"2.6"}

: "----- install packages for dependencies of latest tmux"
${PRVENV_CMD_PKG_INS} libevent-dev libncurses-dev make

: "----- install latest tmux"
${PRVENV_WGETCMD} https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz
tar xvzf tmux-${TMUX_VERSION}.tar.gz

cd tmux-${TMUX_VERSION}
./configure --prefix=/usr/local
make
make install
