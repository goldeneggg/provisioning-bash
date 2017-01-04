#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

: "----- install packages for cui environment"
${PRVENV_CMD_PKG_INS} ncurses-term screen tmux git subversion zsh vim ctags lv daemontools gdb
