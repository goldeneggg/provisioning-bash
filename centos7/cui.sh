#!/bin/bash

usage() {
    cat << __EOT__
Usage: $0

Install initial packages for cui operation environment
__EOT__
}

MYDIR=$(cd $(dirname $0) && pwd)
MYNAME=`basename $0`
WGETCMD="wget --no-check-certificate --no-cache"

# prepare dependency
bash ${MYDIR}/init_ja.sh

# install packages for cui environment
yum -y install ncurses-term screen tmux git svn zsh vim stow ctags

# install lv
yum -y install ncurses-devel
LVVER=451
cd /tmp
if [ -d lv${LVVER} ]
then
  rm -fr lv${LVVER}
  rm -f lv{$LVVER}.tar.gz
fi
${WGETCMD} http://www.ff.iij4u.or.jp/~nrt/freeware/lv${LVVER}.tar.gz
tar xzf lv${LVVER}.tar.gz
cd lv${LVVER}/build
../src/configure --prefix=/usr/local
make
make install

# from remote to local files
#REMOTE_TARGETS=("<REMOTE FILE>")
#LOCAL_DIR=/tmp/remotefile
#mkdir ${LOCAL_DIR}
#for rt in ${REMOTE_TARGETS[@]}
#do
#  ${WGETCMD} -O ${LOCAL_DIR}/`basename ${rt}` ${rt}
#done
