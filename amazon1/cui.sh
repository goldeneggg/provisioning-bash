#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}"; exit 1; }

: "----- install packages for cui environment"
${PRVENV_CMD_PKG_INS} ncurses-term ncurses-devel screen tmux git svn zsh vim stow ctags gcc-c++

# : "----- install lv"
# pushd ${PRVENV_INSTALL_WORK_DIR}
# declare -r LVVER=451
# if [ -d lv${LVVER} ]
# then
#   rm -fr lv${LVVER}
#   rm -f lv{$LVVER}.tar.gz
# fi
#
# ${PRVENV_WGETCMD} http://www.ff.iij4u.or.jp/~nrt/freeware/lv${LVVER}.tar.gz
# tar xzf lv${LVVER}.tar.gz
# pushd lv${LVVER}/build
# ../src/configure --prefix=/usr/local
# make
# make install
