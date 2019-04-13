#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

bash ${MYDIR}/_nginx-src-dep.sh

: "----- download nginx"
declare -r MAJOR_VER="1.15"
declare -r MINOR_VER="11"
declare -r VER=${MAJOR_VER}.${MINOR_VER}
declare -r TAR=nginx-${VER}.tar.gz

pushd ${PRVENV_INSTALL_WORK_DIR}
[ -f ${TAR} ] && rm -f ${TAR}
${PRVENV_WGETCMD} http://nginx.org/download/${TAR}

: "----- check already executing nginx"
[ -f /etc/init/nginx.conf ] && ${PRVENV_CMD_INIT_STOP} nginx

[ -d nginx-${VER} ] && rm -fr nginx-${VER}
tar zxf ${TAR}

: "----- make, install"
# http://wiki.nginx.org/InstallOptions
pushd nginx-${VER}
./configure \
--with-http_v2_module \
--with-http_ssl_module \
--with-debug
make
make install

bash ${MYDIR}/_nginx-src-initscript.sh
