#!/bin/bash

#>>>>>>>>>> prepare
MYNAME=`basename $0`
MYDIR=$(cd $(dirname $0) && pwd)

# load environments
source ${MYDIR}/envs
#<<<<<<<<<<


# prepare dependency
bash ${MYDIR}/init_ja.sh

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
