#!/bin/bash

#>>>>>>>>>> prepare
MYNAME=`basename $0`
MYDIR=$(cd $(dirname $0) && pwd)
MYUSER=$(whoami)

# load environments
source ${MYDIR}/envs
#<<<<<<<<<<


# initial setup
bash ${MYDIR}/init_ja.sh

# download nginx
MAJOR_VER="1.6"
MINOR_VER="2"
VER=${MAJOR_VER}.${MINOR_VER}
TAR=nginx-${VER}.tar.gz

cd ~
if [ -f ${TAR} ]
then
  rm -f ${TAR}
fi
${PRVENV_WGETCMD} http://nginx.org/download/${TAR}

# check already executing nginx
pgrep nginx >/dev/null
if [ $? -eq 0 ]
then
  ${PRVENV_CMD_INIT_STOP} nginx
fi

# install dependencies
bash ${MYDIR}/_nginx-src-dep.sh

# un-archive
if [ -d nginx-${VER} ]
then
  rm -fr nginx-${VER}
fi
tar zxf ${TAR}

# make, install
## http://wiki.nginx.org/InstallOptions
cd nginx-${VER}
./configure \
--with-http_ssl_module
make
make install

# init script
bash ${MYDIR}/_nginx-src-initscript.sh
