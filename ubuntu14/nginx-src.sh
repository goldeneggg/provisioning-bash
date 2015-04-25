#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


if [ ${MYUSER} != "root" ]
then
  echo "${MYUSER} can not run ${MYNAME}"
  exit 1
fi

: "----- download nginx"
declare -r MAJOR_VER="1.8"
declare -r MINOR_VER="0"
declare -r VER=${MAJOR_VER}.${MINOR_VER}
declare -r TAR=nginx-${VER}.tar.gz

cd ~
if [ -f ${TAR} ]
then
  rm -f ${TAR}
fi
${PRVENV_WGETCMD} http://nginx.org/download/${TAR}

: "----- check already executing nginx"
pgrep nginx >/dev/null
if (( $? == 0 ))
then
  ${PRVENV_CMD_INIT_STOP} nginx
fi

bash ${MYDIR}/_nginx-src-dep.sh

if [ -d nginx-${VER} ]
then
  rm -fr nginx-${VER}
fi
tar zxf ${TAR}

: "----- make, install"
# http://wiki.nginx.org/InstallOptions
cd nginx-${VER}
./configure \
--with-http_ssl_module
make
make install

bash ${MYDIR}/_nginx-src-initscript.sh
