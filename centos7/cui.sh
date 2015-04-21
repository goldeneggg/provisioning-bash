#!/bin/bash

#>>>>>>>>>> prepare
MYNAME=`basename $0`
MYDIR=$(cd $(dirname $0) && pwd)
MYUSER=$(whoami)

# load environments
source ${MYDIR}/envs
#<<<<<<<<<<


# root only
if [ ${MYUSER} != "root" ]
then
  echo "${MYUSER} can not run ${MYNAME}"
  exit 1
fi

# install packages for cui environment
${PRVENV_CMD_PKG_INS} ncurses-term ncurses-devel screen tmux git svn zsh vim stow ctags

# install lv
LVVER=451
cd /tmp
if [ -d lv${LVVER} ]
then
  rm -fr lv${LVVER}
  rm -f lv{$LVVER}.tar.gz
fi
${PRVENV_WGETCMD} http://www.ff.iij4u.or.jp/~nrt/freeware/lv${LVVER}.tar.gz
tar xzf lv${LVVER}.tar.gz
cd lv${LVVER}/build
../src/configure --prefix=/usr/local
make
make install

# install stow
STOW_VER="2.2.0"
${PRVENV_WGETCMD} http://ftp.gnu.org/gnu/stow/stow-${STOW_VER}.tar.gz
tar xzf stow-${STOW_VER}.tar.gz
cd stow-${STOW_VER}
./configure --prefix=/usr/local
make
make install
