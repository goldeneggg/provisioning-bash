#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}"; exit 1; }

bash ${MYDIR}/_erlang-src-dep.sh

: "----- download erlang"
declare -r MAJOR_VER=${1:-"17"}
declare -r MINOR_VER=${2:-"5"}

declare -r VER=${MAJOR_VER}.${MINOR_VER}
declare -r TAR=otp_src_${VER}.tar.gz

pushd ${PRVENV_INSTALL_WORK_DIR}
[ -f ${TAR} ] && rm -f ${TAR}

# http://www.erlang.org/download/otp_src_17.5.tar.gz
${PRVENV_WGETCMD} http://www.erlang.org/download/${TAR}

declare -r SRCDIR=${TAR//.tar.gz/}
[ -d ${SRCDIR} ] && rm -fr ${SRCDIR}
tar zxf ${TAR}

: "----- make and install"
declare -r PREFIX=/usr/local/erlang-${VER}

pushd ${SRCDIR}

./configure --prefix=${PREFIX} --enable-smp-support --enable-threads --enable-m64-build --enable-kernel-poll --enable-native-libs --enable-sctp --enable-hipe --with-dynamic-trace=systemtap --enable-vm-probes --without-javac
make
make install

: "----- symlink versioning mysql to non-versioning mysql"
declare -r ERLANG_HOME=/usr/local/erlang
[ -d ${ERLANG_HOME} -o -L ${ERLANG_HOME} ] && rm -fr ${ERLANG_HOME}
ln -s ${PREFIX} ${ERLANG_HOME}

: "----- add mysql bin path into bashrc"
echo "export PATH=${ERLANG_HOME}/bin"':$PATH' >> ${ENV_RC}
source ${ENV_RC}
