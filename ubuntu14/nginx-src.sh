#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


[ $(isroot) ] || (echo "${MYUSER} can not run ${MYNAME}"; exit 1)

: "----- download nginx"
declare -r MAJOR_VER="1.8"
declare -r MINOR_VER="0"
declare -r VER=${MAJOR_VER}.${MINOR_VER}
declare -r TAR=nginx-${VER}.tar.gz

pushd ${PRVENV_INSTALL_WORK_DIR}
[ -f ${TAR} ] && rm -f ${TAR}
${PRVENV_WGETCMD} http://nginx.org/download/${TAR}

: "----- check already executing nginx"
pgrep nginx >/dev/null
(( $? == 0 )) && ${PRVENV_CMD_INIT_STOP} nginx

bash ${MYDIR}/_nginx-src-dep.sh

[ -d nginx-${VER} ] && rm -fr nginx-${VER}
tar zxf ${TAR}

: "----- make, install"
# http://wiki.nginx.org/InstallOptions
pushd nginx-${VER}
./configure \
--with-http_ssl_module
make
make install

bash ${MYDIR}/_nginx-src-initscript.sh
