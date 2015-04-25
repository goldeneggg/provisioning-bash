#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


# root only
if [ ${MYUSER} != "root" ]
then
  echo "${MYUSER} can not run ${MYNAME}"
  exit 1
fi

# install packages for cui environment
${PRVENV_CMD_PKG_INS} ncurses-term screen tmux git subversion zsh vim ctags lv
